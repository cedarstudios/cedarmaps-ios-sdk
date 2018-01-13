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

+ (JSONKeyMapper *)keyMapper {
    NSDictionary *map = @{
                          @"streetName": @"street_name"
                          };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:map];
}

@end
