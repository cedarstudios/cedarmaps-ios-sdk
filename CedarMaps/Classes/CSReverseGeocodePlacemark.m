//
//  CSReverseGeocodePlacemark.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import "CSReverseGeocodePlacemark.h"

@implementation CSReverseGeocodePlacemark

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"components": @"components",
             @"address": @"address",
			 @"formattedAddress": @"formatted_address",
             @"locality": @"locality",
             @"district": @"district",
             @"place": @"place",
             @"city": @"city",
             @"province": @"province",
             @"trafficZone": @"traffic_zone"
             };
}

+ (NSValueTransformer *)componentsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CSReverseGeocodeComponent class]];
}

+ (NSValueTransformer *)trafficZoneJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[CSTrafficZone class]];
}

@end

#pragma mark Traffic Zone

@implementation CSTrafficZone

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"inCentral": @"in_central",
             @"inEvenOdd": @"in_evenodd"
             };
}

@end

#pragma mark Component

@implementation CSReverseGeocodeComponent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"longName": @"long_name",
             @"shortName": @"short_name",
             @"type": @"type"
              };
}

@end
