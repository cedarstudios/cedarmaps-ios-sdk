//
//  CSForwardGeocodePlacemark.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import "CSForwardGeocodePlacemark.h"

@implementation CSForwardGeocodePlacemark

+ (JSONKeyMapper *)keyMapper {
    NSDictionary *map = @{ @"identifier": @"id",
                           @"nameEn": @"name_en",
                           @"region": @"location"
                           };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:map];
}

@end

@implementation CSForwardGeocodeComponent

@end

NSString* stringValueForPlacemarkType(CSPlacemarkType type) {
    NSString *result = @"";
    if (type & CSPlacemarkTypeAll) {
        return result;
    }
    if (type & CSPlacemarkTypeStreet) {
        result = [result stringByAppendingString:@"street,"];
    }
    if (type & CSPlacemarkTypeFreeway) {
        result = [result stringByAppendingString:@"freeway,"];
    }
    if (type & CSPlacemarkTypeLocality) {
        result = [result stringByAppendingString:@"locality,"];
    }
    if (type & CSPlacemarkTypeBoulevard) {
        result = [result stringByAppendingString:@"boulevard,"];
    }
    if (type & CSPlacemarkTypeExpressway) {
        result = [result stringByAppendingString:@"expressway,"];
    }
    if (type & CSPlacemarkTypeRoundabout) {
        result = [result stringByAppendingString:@"roundabout,"];
    }
    if (result.length > 1) {
        result = [result substringToIndex:result.length - 1];
    }
    return result;
}
