//
//  CSRegion.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import "CSRegion.h"

@implementation CSRegion

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"boundingBox": @"bb",
             @"center": @"center"
             };
}

+ (NSValueTransformer *)boundingBoxJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary* dict, BOOL *success, NSError *__autoreleasing *error) {
        NSArray *neComps = [[dict objectForKey:@"ne"] componentsSeparatedByString:@","];
        NSArray *swComps = [[dict objectForKey:@"sw"] componentsSeparatedByString:@","];
        CLLocationCoordinate2D ne = CLLocationCoordinate2DMake([neComps[0] doubleValue], [neComps[1] doubleValue]);
        CLLocationCoordinate2D sw = CLLocationCoordinate2DMake([swComps[0] doubleValue], [swComps[1] doubleValue]);
        return [[CSBoundingBox alloc] initWithNorthEastCoordinate:ne southWestCoordinate:sw];
    } reverseBlock:^id(CSBoundingBox *bb, BOOL *success, NSError *__autoreleasing *error) {
        if (!bb) {
            return nil;
        }
        return @{@"ne": [NSString stringWithFormat:@"%f,%f", bb.northEast.coordinate.latitude, bb.northEast.coordinate.longitude],
                 @"sw": [NSString stringWithFormat:@"%f,%f", bb.southWest.coordinate.latitude, bb.southWest.coordinate.longitude]
                 };
    }];
}

+ (NSValueTransformer *)centerJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString* string, BOOL *success, NSError *__autoreleasing *error) {
        NSArray *comps = [string componentsSeparatedByString:@","];
        return [[CLLocation alloc] initWithLatitude:[comps[0] doubleValue] longitude:[comps[1] doubleValue]];
    } reverseBlock:^id(CLLocation *center, BOOL *success, NSError *__autoreleasing *error) {
        if (center == nil) {
            return nil;
        }
        return [NSString stringWithFormat:@"%f,%f", center.coordinate.latitude, center.coordinate.longitude];
    }];
}

@end
