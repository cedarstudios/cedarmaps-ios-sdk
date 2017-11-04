//
//  CSRegion.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import "CSRegion.h"

@implementation CSRegion

+ (JSONKeyMapper *)keyMapper {
    NSDictionary *map = @{ @"boundingBox": @"bb",
                           };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:map];
}

- (void)setBoundingBoxWithNSDictionary:(NSDictionary *)dic {
    NSArray *neComps = [[dic objectForKey:@"ne"] componentsSeparatedByString:@","];
    NSArray *swComps = [[dic objectForKey:@"sw"] componentsSeparatedByString:@","];
    CLLocationCoordinate2D ne = CLLocationCoordinate2DMake([neComps[0] doubleValue], [neComps[1] doubleValue]);
    CLLocationCoordinate2D sw = CLLocationCoordinate2DMake([swComps[0] doubleValue], [swComps[1] doubleValue]);
    _boundingBox = [[CSBoundingBox alloc] initWithNorthEastCoordinate:ne southWestCoordinate:sw];
}

- (NSDictionary *)JSONObjectForBoundingBox {
    if (_boundingBox == nil) {
        return nil;
    }
    return @{@"ne": [NSString stringWithFormat:@"%f,%f", _boundingBox.northEast.coordinate.latitude, _boundingBox.northEast.coordinate.longitude],
             @"sw": [NSString stringWithFormat:@"%f,%f", _boundingBox.southWest.coordinate.latitude, _boundingBox.southWest.coordinate.longitude]
             };
}

- (void)setCenterWithNSString:(NSString *)string {
    NSArray *comps = [string componentsSeparatedByString:@","];
    _center = [[CLLocation alloc] initWithLatitude:[comps[0] doubleValue] longitude:[comps[1] doubleValue]];
}

- (NSString *)JSONObjectForCenter {
    if (_center == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"%f,%f", _center.coordinate.latitude, _center.coordinate.longitude];
}

@end
