//
//  CSBoundingBox.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import "CSBoundingBox.h"

@implementation CSBoundingBox

- (instancetype)initWithNorthEastCoordinate:(CLLocationCoordinate2D)northEast southWestCoordinate:(CLLocationCoordinate2D)southWest {
    self = [super init];
    if (self) {
        self.northEast = [[CLLocation alloc] initWithLatitude:northEast.latitude longitude:northEast.longitude];
        self.southWest = [[CLLocation alloc] initWithLatitude:southWest.latitude longitude:southWest.longitude];
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"northEast": @"ne",
             @"southWest": @"sw"
             };
}

+ (NSValueTransformer *)northEastJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^CLLocation* (NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return [self CLLocationFromNSString:value];
    } reverseBlock:^NSString* (CLLocation *location, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    }];
}

+ (NSValueTransformer *)southWestJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^CLLocation* (NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return [self CLLocationFromNSString:value];
    } reverseBlock:^NSString* (CLLocation *location, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    }];
}

+ (CLLocation *)CLLocationFromNSString:(NSString *)string {
    NSArray *comps = [string componentsSeparatedByString:@","];
    return [[CLLocation alloc] initWithLatitude:[comps[0] doubleValue] longitude:[comps[1] doubleValue]];
}

@end
