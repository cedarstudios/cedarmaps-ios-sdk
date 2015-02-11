//
//  CSAuthenticationManager.h
//  Pods
//
//  Created by Emad A. on 3/02/2015.
//
//

#import <Foundation/Foundation.h>

@interface CSAuthenticationManager : NSObject

@property (nonatomic, copy, readonly) NSString *clientId;
@property (nonatomic, copy, readonly) NSString *clientSecret;

@property (nonatomic, copy, readonly) NSString *accessToken;

- (void)setCredentialsWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret;
- (void)requestAccessToken:(NSError *__autoreleasing *)error;
- (void)invalidateCredential;

+ (CSAuthenticationManager *)sharedManager;

@end
