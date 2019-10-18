//
//  CSAppDelegate.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/21/2017.
//  Copyright (c) 2017 Saeed Taheri. All rights reserved.
//

#import "CSAppDelegate.h"
#import <CedarMaps/CSMapKit.h>

@implementation CSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Credentials" ofType:@"plist"];
    NSDictionary *credentialsDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSString *clientID = credentialsDic[@"CLIENT_ID"];
    NSString *clientSecret = credentialsDic[@"CLIENT_SECRET"];
    
    if (!clientID || !clientSecret) {
        [NSException raise:@"ClientID or ClientSecret not provided"
                    format:@"You should provide your own clientID and clientSecret for this app to function. We use a Plist file which is not available to you since it's in gitignore file"];
    }
    
    [[CSMapKit sharedMapKit] setCredentialsWithClientID:clientID
                                           clientSecret:clientSecret];
    [[CSMapKit sharedMapKit] setMapIndex:CSMapIndexMix];
    
    [[CSMapKit sharedMapKit] prepareMapTiles:^(BOOL isReady, NSError * _Nullable error) {
		if (isReady) {
			NSLog(@"Map Tiles are ready");
		} else {
			NSLog(@"Map Tiles are not ready. Check error: %@", error.localizedDescription);
		}
    }];
    
    return YES;
}

@end
