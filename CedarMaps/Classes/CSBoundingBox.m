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

+ (JSONKeyMapper *)keyMapper {
    NSDictionary *map = @{ @"northEast": @"ne",
                           @"southWest": @"sw"
                           };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:map];
}

- (void)setNorthEastWithString:(NSString *)string {
    _northEast = [self CLLocationFromNSString:string];
}

- (NSString *)JSONObjectForNorthEast {
    return [self JSONObjectFromCLLocation:_northEast];
}

- (void)setSouthWestWithString:(NSString *)string {
    _southWest = [self CLLocationFromNSString:string];
}

- (NSString *)JSONObjectForSouthWest {
    return [self JSONObjectFromCLLocation:_southWest];
}

- (CLLocation *)CLLocationFromNSString:(NSString *)string {
    NSArray *comps = [string componentsSeparatedByString:@","];
    return [[CLLocation alloc] initWithLatitude:[comps[0] doubleValue] longitude:[comps[1] doubleValue]];
}

- (NSString *)JSONObjectFromCLLocation:(CLLocation *)location {
    return [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
}

@end
