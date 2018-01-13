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

- (void)setBoundingBoxWithNSArray:(NSArray *)array {
    if (array && array.count == 4) {
        CLLocationCoordinate2D ne = CLLocationCoordinate2DMake([array[3] doubleValue], [array[2] doubleValue]);
        CLLocationCoordinate2D sw = CLLocationCoordinate2DMake([array[1] doubleValue], [array[0] doubleValue]);
        _boundingBox = [[CSBoundingBox alloc] initWithNorthEastCoordinate:ne southWestCoordinate:sw];
    }
}

- (NSArray *)JSONObjectForBoundingBox {
    if (_boundingBox == nil) {
        return nil;
    }
    return @[
             [NSNumber numberWithDouble:_boundingBox.southWest.coordinate.longitude],
             [NSNumber numberWithDouble:_boundingBox.southWest.coordinate.latitude],
             [NSNumber numberWithDouble:_boundingBox.northEast.coordinate.longitude],
             [NSNumber numberWithDouble:_boundingBox.northEast.coordinate.latitude]
             ];
}

- (void)setPointsWithNSArray:(NSArray *)array {
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:array.count];

    for (NSArray *item in array) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[item[1] doubleValue] longitude:[item[0] doubleValue]];
        [points addObject:location];
    }
    
    _points = [points copy];
}

- (NSArray *)JSONObjectForPoints {
    if (_points == nil) {
        return nil;
    }
    
    NSMutableArray *coordinates = [NSMutableArray arrayWithCapacity:_points.count];

    for (CLLocation *item in _points) {
        NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:2];
        [itemArray addObject:[NSNumber numberWithDouble:item.coordinate.longitude]];
        [itemArray addObject:[NSNumber numberWithDouble:item.coordinate.latitude]];
        
        [coordinates addObject:itemArray.copy];
    }
    
    return [coordinates copy];
}

+ (JSONKeyMapper *)keyMapper {
    NSDictionary *map = @{
                          @"points": @"geometry.coordinates",
                          @"boundingBox": @"bbox"
                          };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:map];
}

@end
