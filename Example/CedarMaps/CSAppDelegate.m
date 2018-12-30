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

    [[CSMapKit sharedMapKit] setCredentialsWithClientID:@"CLIENT_ID"
                                           clientSecret:@"CLIENT_STREET"];
    [[CSMapKit sharedMapKit] setMapID:@"cedarmaps.mix"];
    
    [[CSMapKit sharedMapKit] prepareMapTiles:^(BOOL isReady, NSError * _Nullable error) {
        
    }];
    
    return YES;
}

@end
