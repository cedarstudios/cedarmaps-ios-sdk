//
//  CSAuthenticationManager.m
//  Pods
//
//  Created by Emad A. on 3/02/2015.
//
//

#import "CSAuthenticationManager.h"

static NSString * const kBaseURL = @"http://abcdertymaps.cedar.ir/api/v1";

@implementation CSAuthenticationManager

- (void)setCredentialsWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret
{
    NSAssert(clientId     != nil && clientId.length     > 0, @"Given Client ID is not in acceptable format.");
    NSAssert(clientSecret != nil && clientSecret.length > 0, @"Given Client Secret is not in acceptable format.");

    _clientId = clientId;
    _clientSecure = clientSecret;
}

- (void)requestAccessToken
{
    NSAssert(self.clientId      != nil, @"No client id specified. Set your given credentials before trying to get an access token.");
    NSAssert(self.clientSecure  != nil, @"No client Secret specified. Set your given credentials before trying to get an access token.");

    NSString *params = [NSString stringWithFormat:@"grant_type=client_credentials&client_id=%@&client_secret=%@", self.clientId, self.clientSecure];
    params = [params stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *tokenURL = [NSURL URLWithString:kBaseURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tokenURL];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];

    NSError *error = nil;
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    NSLog(@"response: %@",response);
    NSLog(@"error: %@",error);
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
