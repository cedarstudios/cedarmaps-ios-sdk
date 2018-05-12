//
//  CSReverseGeocodeResponse.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import "CSReverseGeocodeResponse.h"

@implementation CSReverseGeocodeResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"result": @"result",
             @"status": @"status"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[CSReverseGeocodePlacemark class]];
}

@end
