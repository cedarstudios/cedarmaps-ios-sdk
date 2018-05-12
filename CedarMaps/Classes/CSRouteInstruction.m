//
//  CSRouteInstruction.m
//  CedarMaps
//
//  Created by Saeed Taheri on 1/13/18.
//

#import "CSRouteInstruction.h"

@implementation CSRouteInstruction

- (NSTimeInterval)time {
    return _time / 1000;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"distance": @"distance",
             @"sign": @"sign",
             @"time": @"time",
             @"interval": @"interval",
             @"text": @"text",
             @"streetName": @"street_name"
             };
}

@end
