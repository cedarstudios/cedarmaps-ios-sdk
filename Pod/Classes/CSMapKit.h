//
//  CSMapStyle.h
//  Pods
//
//  Created by Emad A. on 30/01/2015.
//
//

@import CoreLocation;

@class CSQueryParameters;
@class CSDistancePoints;

/* A CSMapKit is used to display map tiles from a network-based map hosted on CedarMaps as well as getting geocoding data from server.
 * Maps should be referenced by their map ID.
 */

@interface CSMapKit: NSObject

@property (nonatomic, copy, readonly) NSString *mapID;

- (instancetype)initWithMapID:(NSString *)mapID;
- (void)styleURLWithCompletion:(void (^) (NSURL *url))completion;

- (void)distanceBetweenPoints:(CSDistancePoints *)points withCompletion:(void (^) (NSArray *results, NSError *error))completion;
- (void)forwardGeocodingWithQueryString:(NSString *)query
                             parameters:(CSQueryParameters *)parameters
                             completion:(void (^)(NSArray *results, NSError *error))completion;
- (void)reverseGeocodingWithCoordinate:(CLLocationCoordinate2D)coordinate
                            completion:(void (^)(NSDictionary *result, NSError *error))completion;

@end

#pragma mark

@interface CSQueryParameters : NSObject

- (void)addCity:(NSString *)city;
- (void)addLimit:(NSUInteger)limit;
- (void)addDistance:(CLLocationDistance)distance;
- (void)addLocationWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end

#pragma mark

@interface CSDistancePoints: NSObject

- (void)addCoordinatePairWithDeparture:(CLLocationCoordinate2D)departure destination:(CLLocationCoordinate2D)destination;

@end
