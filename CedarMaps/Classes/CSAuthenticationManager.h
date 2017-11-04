#import <Foundation/Foundation.h>

static NSString * _Nonnull const kCedarMapsAccessTokenIsReadeyNotification = @"kCedarMapsAccessTokenIsReadeyNotification";

@interface CSAuthenticationManager : NSObject

@property (nonatomic, strong, readonly, nullable) NSString *clientID;
@property (nonatomic, strong, readonly, nullable) NSString *clientSecret;
@property (nonatomic, strong, nullable) NSString *baseURL;

@property (class, readonly, strong, nonnull) CSAuthenticationManager *sharedAuthenticationManager;

- (void)setCredentialsWithClientID:(nonnull NSString *)clientID clientSecret:(nonnull NSString *)clientSecret;
- (BOOL)isAccessTokenSaved;
- (void)accessToken:(nonnull void (^) ( NSString * _Nullable token,  NSError * _Nullable error))completion;
- (void)refetchAccessToken;

@end
