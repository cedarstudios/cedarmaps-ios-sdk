//
//  CSAuthenticationManager.m
//  Pods
//
//  Created by Emad A. on 3/02/2015.
//
//

#import "CSAuthenticationManager.h"

static NSString * const kBaseURL = @"https://api.cedarmaps.com/v1";
static NSString * const kCurrentAccessToken = @"CedarMapsSDKUserAccessToken_v1";

@interface CSAuthenticationManager ()

@property (nonatomic, strong) NSString *accessToken;

@end

@implementation CSAuthenticationManager

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.baseURL = kBaseURL.copy;
    }

    return self;
}

- (void)savedAccessToken:(void (^) (NSString *token))completion {
    if (!_accessToken) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _accessToken = [defaults objectForKey:kCurrentAccessToken];
        if (!_accessToken) {
            [self requestAccessTokenFromServer:^(NSString *token, NSError *error) {
                completion(token);
            }];
        } else {
            completion(_accessToken);
        }
    } else {
        completion(_accessToken);
    }
}

- (void)setCredentialsWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret
{
    NSAssert(clientID != nil && clientID.length > 0, @"Given Client ID is not in acceptable format.");
    NSAssert(clientSecret != nil && clientSecret.length > 0, @"Given Client Secret is not in acceptable format.");

    _clientID = clientID;
    _clientSecret = clientSecret;
}

- (void)requestAccessTokenFromServer:(void (^)(NSString *token, NSError *error))completion
{
    NSAssert(self.clientID != nil, @"No client id specified. Set your given credentials before trying to get an access token.");
    NSAssert(self.clientSecret != nil, @"No client Secret specified. Set your given credentials before trying to get an access token.");

    NSString *params = [NSString stringWithFormat:@"client_id=%@&client_secret=%@", self.clientID, self.clientSecret];
    params = [params stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *tokenURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/token", self.baseURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tokenURL];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable token, NSURLResponse * _Nullable response, NSError * _Nullable responseError) {
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
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
                
                completion(_accessToken, nil);
                return;
            } else if (responseError != nil) {
                completion(nil, responseError);
                return;
            }
        } else if (responseError != nil) {
            completion(nil, responseError);
            return;
        }
    }] resume];
}

- (void)invalidateCredential
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kCurrentAccessToken];
    [defaults synchronize];

    _accessToken = nil;
}

#pragma mark - Singleton Methods

static CSAuthenticationManager *sharedInstance;

+ (void)initialize
{
    static BOOL initialized = NO;
    if (initialized == NO) {
        initialized = YES;
        sharedInstance = [[CSAuthenticationManager alloc] init];
    }
}

+ (CSAuthenticationManager *)sharedManager
{
    return sharedInstance;
}

@end
