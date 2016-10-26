//
//  CSMapStyle.h
//  Pods
//
//  Created by Emad A. on 30/01/2015.
//
//

@import CoreLocation;

/*
 *  CoordinatesTuple
 *
 *  Discussion:
 *    A structure that contains two geographical coordinates.
 *
 *  Fields:
 *    departure:
 *      The departure in CLLocationCoordinate2D.
 *    destination:
 *      The destination in CLLocationCoordinate2D.
 */
struct CoordinatesTuple {
    CLLocationCoordinate2D departure;
    CLLocationCoordinate2D destination;
};
typedef struct CoordinatesTuple CoordinatesTuple;

/*
 *  CoordinatesTupleMake:
 *
 *  Discussion:
 *    Returns a new CoordinatesTuple at the given departure and destination
 */
CoordinatesTuple CoordinatesTupleMake(CLLocationCoordinate2D departure, CLLocationCoordinate2D destination);


@class CSQueryParameters;

/* A CSMapKit is used to display map tiles from a network-based map hosted on CedarMaps as well as getting geocoding data from server.
 * Maps should be referenced by their map ID.
 */

@interface CSMapKit: NSObject

@property (nonatomic, copy, readonly) NSString *mapID;

- (instancetype)initWithMapID:(NSString *)mapID;
- (void)styleURLWithCompletion:(void (^) (NSURL *url))completion;

- (void)distanceWithCompletionHandler:(void (^) (NSArray *results, NSError *error))completion betweenPoints:(CoordinatesTuple)firstArg, ...;
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
