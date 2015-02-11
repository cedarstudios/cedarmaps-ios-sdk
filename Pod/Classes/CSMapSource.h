//
//  CSMapSource.h
//  Pods
//
//  Created by Emad A. on 30/01/2015.
//
//

#import "Mapbox.h"

@class CSQueryParameters;

/* An CSMapSource is used to display map tiles from a network-based map hosted on Cedar Map.
 * Map should be referenced by their map ID.
 */

@interface CSMapSource : RMAbstractWebMapSource

@property (nonatomic, copy, readonly) NSString *mapId;

@property (nonatomic, readonly) NSString *version;
@property (nonatomic, readonly) RMSphericalTrapezium bounds;

- (id)initWithMapId:(NSString *)mapId;
- (id)initWithMapId:(NSString *)mapId enablingDataOnMapView:(RMMapView *)mapView;
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
- (void)addDistance:(CGFloat)distance;
- (void)addLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

@end

#define CSMapSourceErrorNotification @"CSMapSourceErrorNotification"