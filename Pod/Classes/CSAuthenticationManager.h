//
//  CSAuthenticationManager.h
//  Pods
//
//  Created by Emad A. on 3/02/2015.
//
//

#import <Foundation/Foundation.h>

@interface CSAuthenticationManager : NSObject

@property (nonatomic, copy, readonly) NSString *clientID;
@property (nonatomic, copy, readonly) NSString *clientSecret;

@property (nonatomic, copy) NSString *baseURL;

+ (CSAuthenticationManager *)sharedManager;

- (void)setCredentialsWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret;
- (void)requestAccessTokenFromServer:(void (^)(NSString *token, NSError *error))completion;
- (void)savedAccessToken:(void (^) (NSString *token))completion;
- (void)invalidateCredential;

@end
