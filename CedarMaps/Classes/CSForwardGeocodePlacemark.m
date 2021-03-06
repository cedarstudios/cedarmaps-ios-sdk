//
//  CSForwardGeocodePlacemark.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import "CSForwardGeocodePlacemark.h"

@implementation CSForwardGeocodePlacemark

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier": @"id",
             @"name": @"name",
             @"alternateName": @"alt_name",
             @"nameEn": @"name_en",
             @"type": @"type",
             @"region": @"location",
             @"category": @"category",
             @"slug": @"slug",
             @"address": @"address",
             @"components": @"components"
             };
}

+ (NSValueTransformer *)regionJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[CSRegion class]];
}

@end

@implementation CSForwardGeocodeComponent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"country": @"country",
             @"province": @"province",
             @"city": @"city",
             @"districts": @"districts",
             @"localities": @"localities"
             };
}

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
    if (type & CSPlacemarkTypePOI) {
        result = [result stringByAppendingString:@"poi,"];
    }
    if (type & CSPlacemarkTypeCity) {
        result = [result stringByAppendingString:@"city,"];
    }
    if (type & CSPlacemarkTypeState) {
        result = [result stringByAppendingString:@"state,"];
    }
    if (type & CSPlacemarkTypeVillage) {
        result = [result stringByAppendingString:@"village,"];
    }
    if (type & CSPlacemarkTypeTown) {
        result = [result stringByAppendingString:@"town,"];
    }
    if (type & CSPlacemarkTypeJunction) {
        result = [result stringByAppendingString:@"junction,"];
    }
    if (type & CSPlacemarkTypeRegion) {
        result = [result stringByAppendingString:@"region,"];
    }
    if (result.length > 1) {
        result = [result substringToIndex:result.length - 1];
    }
    return result;
}
