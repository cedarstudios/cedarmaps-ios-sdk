//
//  CSDirectionCompleteResponse.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/25/17.
//

#import "CSDirectionResponse.h"

@implementation CSDirectionResponse

+ (JSONKeyMapper *)keyMapper {
    NSDictionary *map = @{ @"routes": @"result.routes"
                           };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:map];
}

@end
