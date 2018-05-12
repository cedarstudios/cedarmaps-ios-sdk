//
//  CSForwardGeocodeResponse.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import "CSForwardGeocodeResponse.h"

@implementation CSForwardGeocodeResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"results": @"results",
             @"status": @"status"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CSForwardGeocodePlacemark class]];
}

@end
