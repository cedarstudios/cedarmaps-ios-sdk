//
//  CSDirectionResponse.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/25/17.
//

#import "CSRoute.h"

@implementation CSRoute

- (NSTimeInterval)time {
    return _time / 1000;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"points": @"geometry.coordinates",
             @"boundingBox": @"bbox",
             @"distance": @"distance",
             @"time": @"time",
             @"instructions": @"instructions"
             };
}

+ (NSValueTransformer *)boundingBoxJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray* array, BOOL *success, NSError *__autoreleasing *error) {
        if (!array || array.count != 4) {
            return nil;
        }
        CLLocationCoordinate2D ne = CLLocationCoordinate2DMake([array[3] doubleValue], [array[2] doubleValue]);
        CLLocationCoordinate2D sw = CLLocationCoordinate2DMake([array[1] doubleValue], [array[0] doubleValue]);
        return [[CSBoundingBox alloc] initWithNorthEastCoordinate:ne southWestCoordinate:sw];
    } reverseBlock:^id(CSBoundingBox *bb, BOOL *success, NSError *__autoreleasing *error) {
        if (!bb) {
            return nil;
        }
        return @[
                 [NSNumber numberWithDouble:bb.southWest.coordinate.longitude],
                 [NSNumber numberWithDouble:bb.southWest.coordinate.latitude],
                 [NSNumber numberWithDouble:bb.northEast.coordinate.longitude],
                 [NSNumber numberWithDouble:bb.northEast.coordinate.latitude]
                 ];
    }];
}

+ (NSValueTransformer *)pointsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray* array, BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:array.count];
        
        for (NSArray *item in array) {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[item[1] doubleValue] longitude:[item[0] doubleValue]];
            [points addObject:location];
        }
        
        return [points copy];
    } reverseBlock:^id(NSArray *points, BOOL *success, NSError *__autoreleasing *error) {
        if (points == nil) {
            return nil;
        }
        
        NSMutableArray *coordinates = [NSMutableArray arrayWithCapacity:points.count];
        
        for (CLLocation *item in points) {
            NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:2];
            [itemArray addObject:[NSNumber numberWithDouble:item.coordinate.longitude]];
            [itemArray addObject:[NSNumber numberWithDouble:item.coordinate.latitude]];
            
            [coordinates addObject:itemArray.copy];
        }
        
        return [coordinates copy];
    }];
}

+ (NSValueTransformer *)instructionsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CSRouteInstruction class]];
}

@end
