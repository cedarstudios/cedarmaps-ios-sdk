//
//  CSDirectionCompleteResponse.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/25/17.
//

#import "CSDirectionResponse.h"

@implementation CSDirectionResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"routes": @"result.routes",
             @"status": @"status"
             };
}

+ (NSValueTransformer *)routesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CSRoute class]];
}

@end
