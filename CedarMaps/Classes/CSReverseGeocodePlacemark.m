//
//  CSReverseGeocodePlacemark.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import "CSReverseGeocodePlacemark.h"

@implementation CSReverseGeocodePlacemark

+ (JSONKeyMapper *)keyMapper {
    NSDictionary *map = @{ @"trafficZone": @"traffic_zone"
                           };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:map];
}

@end

#pragma mark Traffic Zone

@implementation CSTrafficZone

+ (JSONKeyMapper *)keyMapper {
    NSDictionary *map = @{ @"inEvenOdd": @"in_evenodd",
                           @"inCentral": @"in_central"
                           };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:map];
}

@end

#pragma mark Component

@implementation CSReverseGeocodeComponent

+ (JSONKeyMapper *)keyMapper {
    NSDictionary *map = @{ @"longName": @"long_name",
                           @"shortName": @"short_name"
                           };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:map];
}

@end
