#import "CSAuthenticationManager.h"
#import "CSError.h"

static NSString * const kBaseURL = @"https://api.cedarmaps.com/v1/";
static NSString * const kCurrentAccessToken = @"CedarMapsSDKUserAccessToken_v1";

@interface CSAuthenticationManager ()

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, assign) BOOL isFetchingAccessToken;

@end

@implementation CSAuthenticationManager

+ (instancetype)sharedAuthenticationManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

+ (NSURLSession *)sharedURLSession {
    static id _sharedSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    });
    
    return _sharedSession;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.baseURL = kBaseURL;
        self.isFetchingAccessToken = NO;
    }

    return self;
}

- (void)setBaseURL:(NSString *)baseURL {
    if (baseURL) {
        _baseURL = baseURL;
    } else {
        _baseURL = kBaseURL;
    }
}

- (BOOL)isAccessTokenSaved {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kCurrentAccessToken]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)accessToken:(nonnull void (^)(NSString * _Nullable, NSError * _Nullable))completion {
    if (!_accessToken) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _accessToken = [defaults objectForKey:kCurrentAccessToken];
        
        if (!_accessToken) {
            [self requestAccessTokenFromServer:completion];
        } else {
            completion(_accessToken, nil);
        }
    } else {
        completion(_accessToken, nil);
    }
}

- (void)setCredentialsWithClientID:(nonnull NSString *)clientID clientSecret:(nonnull NSString *)clientSecret {
    NSAssert(clientID != nil && clientID.length > 0, @"Given Client ID is empty.");
    NSAssert(clientSecret != nil && clientSecret.length > 0, @"Given Client Secret is empty.");
    
    _clientID = clientID;
    _clientSecret = clientSecret;
}

- (void)requestAccessTokenFromServer:(nonnull void (^)(NSString *token, NSError *error))completion
{
    NSAssert(self.clientID != nil, @"No Client ID was specified. Set your given credentials before trying to get an access token.");
    NSAssert(self.clientSecret != nil, @"No Client Secret was specified. Set your given credentials before trying to get an access token.");

    NSString *params = [NSString stringWithFormat:@"client_id=%@&client_secret=%@", self.clientID, self.clientSecret];
    params = [params stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *tokenURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@token", self.baseURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tokenURL];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];

    [[[CSAuthenticationManager sharedURLSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable token, NSURLResponse * _Nullable response, NSError * _Nullable responseError) {
        
        if (responseError != nil) {
            completion(nil, responseError);
            return;
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode == 200) {
                NSError *serializationError;
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:token options:0 error:&serializationError];
                if (serializationError != nil) {
                    completion(nil, serializationError);
                    return;
                }
                
                _accessToken = result[@"access_token"];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:_accessToken forKey:kCurrentAccessToken];
                if (_accessToken) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kCedarMapsAccessTokenIsReadeyNotification object:nil userInfo:@{kCedarMapsAccessTokenIsReadeyNotification: _accessToken}];
                }
                
                completion(_accessToken, nil);
                return;
            } else {
                completion(nil, [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:nil]);
                return;
            }
        } else {
            completion(nil, [CSError errorWithDescription:@"Unknown error occurred in getting access token."]);
            return;
        }
    }] resume];
}

- (void)refetchAccessToken {
    if (self.isFetchingAccessToken) {
        return;
    }
    self.isFetchingAccessToken = YES;
    [self invalidateCredentials];
    
    __weak CSAuthenticationManager *weakSelf = self;
    [self requestAccessTokenFromServer:^(NSString *token, NSError *error) {
        weakSelf.isFetchingAccessToken = NO;
    }];
}

- (void)invalidateCredentials
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kCurrentAccessToken];
    [defaults synchronize];

    _accessToken = nil;
}


@end
