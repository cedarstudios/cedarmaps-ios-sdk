//
//  CSAuthenticationManager.m
//  Pods
//
//  Created by Emad A. on 3/02/2015.
//
//

#import "CSAuthenticationManager.h"

static NSString * const kBaseURL = @"http://api.cedarmaps.com/v1";
static NSString * const kCurrentAccessToken = @"CedarMapsSDKUserAccessToken_v1";

@interface CSAuthenticationManager () {
    NSString *_accessToken;
}

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

- (NSString *)accessToken
{
    if (_accessToken == nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _accessToken = [defaults objectForKey:kCurrentAccessToken];

        if (_accessToken == nil) {
            [self requestAccessToken:nil];
        }
    }

    return _accessToken;
}

- (void)setCredentialsWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret
{
    NSAssert(clientId     != nil && clientId.length     > 0, @"Given Client ID is not in acceptable format.");
    NSAssert(clientSecret != nil && clientSecret.length > 0, @"Given Client Secret is not in acceptable format.");

    _clientId = clientId;
    _clientSecret = clientSecret;
}

- (void)requestAccessToken:(NSError *__autoreleasing *)error
{
    NSAssert(self.clientId      != nil, @"No client id specified. Set your given credentials before trying to get an access token.");
    NSAssert(self.clientSecret  != nil, @"No client Secret specified. Set your given credentials before trying to get an access token.");

    NSString *params = [NSString stringWithFormat:@"client_id=%@&client_secret=%@", self.clientId, self.clientSecret];
    params = [params stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *tokenURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/token", self.baseURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tokenURL];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];

    NSError *responseError = nil;
    NSHTTPURLResponse *response = nil;
    NSData *token = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];

    if (response.statusCode == 200) {
        NSError *serializationError = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:token options:0 error:&serializationError];
        if (serializationError != nil && error != nil) {
            *error = serializationError;
            return;
        }

        _accessToken = result[@"access_token"];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_accessToken forKey:kCurrentAccessToken];
        [defaults synchronize];
    }
    else if (responseError != nil && error != nil) {
        *error = responseError;
    }
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
