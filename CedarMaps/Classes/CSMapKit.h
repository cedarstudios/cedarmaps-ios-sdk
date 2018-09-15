#import <CoreLocation/CoreLocation.h>
#import "CSForwardGeocodePlacemark.h"
#import "CSReverseGeocodePlacemark.h"
#import "CSRoute.h"
#import "CSRoutePair.h"
#import "CSBoundingBox.h"
#import "CSMapSnapshot.h"
#import "CSMapSnapshotOptions.h"


/**
 * This class is the single point entry for using CedarMaps API on iOS.
 * The setup and using methods process are done through this class.
 *
 * You should ALWAYS use the provided sharedMapKit class property to initialize an instance
 * of this class.
 */
@interface CSMapKit: NSObject


/**
 * The shared CSMapKit session which can be used to setup, configure,
 * and use CedarMaps API methods.
 *
 */
@property (class, readonly, strong, nonnull) CSMapKit *sharedMapKit;


/**
 * Use this method to setup CedarMaps API and should be called before any other methods in this framework.
 *
 * ClientID and ClientSecret are given to you when you asked for CedarMaps API access.

 @param clientID The Client ID you were given
 @param clientSecret The Client Secret you were given
 */
- (void)setCredentialsWithClientID:(nonnull NSString *)clientID
                      clientSecret:(nonnull NSString *)clientSecret;


/**
 * Use this method to set the baseURL for using CedarMaps API.
 * If you are given a different baseURL for using CedarMaps API, set it here.
 * This method should be called during setup before using any of the CedarMaps methods.
 
 @param urlString If you pass nil, the SDK uses the default baseURL.
 */
- (void)setAPIBaseURL:(nullable NSString*)urlString;

/**
 * Use this property to control result types.
 * Possible values are "cedarmaps.streets" and "cedarmaps.mix".
 * By setting "cedarmaps.mix", POI search results are available.
 */
@property (nonatomic, strong, nonnull) NSString *mapID;

/**
 This method should be called before using CedarMaps map tiles using CSMapView.

 @param completionHandler This handler is called when the process of preparing map tiles
 * is completed. The block will be called on the main_queue.
 @see CSMapView.h
 */
- (void)prepareMapTiles:(nonnull void (^) (BOOL isReady, NSError * _Nullable error))completionHandler;


/**
 This method will get you the textual address components related to a particular coordiante.

 @param location The location for which the address components would be generated.
 @param completionHandler This handler is called when the process of fetching reverse geocode
 * result is completed. The block will be called on the main_queue.
 */
- (void)reverseGeocodeLocation:(nonnull CLLocation *)location
             completionHandler:(nonnull CSReverseGeocodeCompletionHandler)completionHandler;


/**
 This method will search for an address using the provided string query.

 @param addressString The address query to search.
 @param completionHandler This handler is called when the process of fetching forward geocode
 * results is completed. The block will be called on the main_queue.
 */
- (void)geocodeAddressString:(nonnull NSString *)addressString
           completionHandler:(nonnull CSForwardGeocodeCompletionHandler)completionHandler;


/**
 This method will search for an address using the provided string query.

 @param addressString The address query to search.
 @param type The placemark types to include in search results. This can be a combination of values.
 @param limit The maximum number of results to return.
 @param completionHandler This handler is called when the process of fetching forward geocode
 * results is completed. The block will be called on the main_queue.
 */
- (void)geocodeAddressString:(nonnull NSString *)addressString
                    withType:(CSPlacemarkType)type
                       limit:(NSInteger)limit
           completionHandler:(nonnull CSForwardGeocodeCompletionHandler)completionHandler;


/**
 This method will search for an address using the provided string query.

 @param addressString The address query to search.
 @param region The circular region consisting of a center coordinate and a radius to limit the search results.
 @param completionHandler This handler is called when the process of fetching forward geocode
 * results is completed. The block will be called on the main_queue.
 */
- (void)geocodeAddressString:(nonnull NSString *)addressString
                    inRegion:(nonnull CLCircularRegion *)region
           completionHandler:(nonnull CSForwardGeocodeCompletionHandler)completionHandler;


/**
 This method will search for an address using the provided string query.

 @param addressString The address query to search.
 @param region The circular region consisting of a center coordinate and a radius to limit the search results.
 @param type The placemark types to include in search results. This can be a combination of values.
 @param limit The maximum number of results to return.
 @param completionHandler This handler is called when the process of fetching forward geocode
 * results is completed. The block will be called on the main_queue.
 */
- (void)geocodeAddressString:(nonnull NSString *)addressString
                    inRegion:(nonnull CLCircularRegion *)region
                    withType:(CSPlacemarkType)type
                       limit:(NSInteger)limit
           completionHandler:(nonnull CSForwardGeocodeCompletionHandler)completionHandler;


/**
 This method will search for an address using the provided string query.

 @param addressString The address query to search.
 @param boundingBox The rectangular region consisting of a north east and south west coordinates to limit the search results.
 @param completionHandler This handler is called when the process of fetching forward geocode
 * results is completed. The block will be called on the main_queue.
 */
- (void)geocodeAddressString:(nonnull NSString *)addressString
               inBoundingBox:(nonnull CSBoundingBox *)boundingBox
           completionHandler:(nonnull CSForwardGeocodeCompletionHandler)completionHandler;


/**
 This method will search for an address using the provided string query.

 @param addressString The address query to search.
 @param boundingBox The rectangular region consisting of a north east and south west coordinates to limit the search results.
 @param type The placemark types to include in search results. This can be a combination of values.
 @param limit The maximum number of results to return.
 @param completionHandler This handler is called when the process of fetching forward geocode
 * results is completed. The block will be called on the main_queue.
 */
- (void)geocodeAddressString:(nonnull NSString *)addressString
               inBoundingBox:(nonnull CSBoundingBox *)boundingBox
                    withType:(CSPlacemarkType)type
                       limit:(NSInteger)limit
           completionHandler:(nonnull CSForwardGeocodeCompletionHandler)completionHandler;


/**
 Implementation is not final yet. DO NOT USE.
 */
- (void)geocodeAddressString:(nonnull NSString *)addressString
                 inProximity:(CLLocationCoordinate2D)coordinate
                    withType:(CSPlacemarkType)type
                       limit:(NSInteger)limit
           completionHandler:(nonnull CSForwardGeocodeCompletionHandler)completionHandler;

/**
 * This method calculates directions using car profile between a source and a destination.
 *
 * Up to 100 pairs of source and destionation points can be provided to calculate a multiple step routing.

 @param routePairs An array of CSRoutePair consisting of source and destination points.
 @param completionHandler This handler is called when the process of fetching direction
 * results is completed. The block will be called on the main_queue.
 @see CSRoutePair.h
 */
- (void)calculateDirections:(nonnull NSArray<CSRoutePair *> *)routePairs withCompletionHandler:(nonnull CSDirectionCompletionHandler)completionHandler;

/**
 * This method calculates directions with verbal instructions using car profile between a source and a destination.
 *
 * Up to 100 pairs of source and destionation points can be provided to calculate a multiple step routing.
 
 @param routePairs An array of CSRoutePair consisting of source and destination points.
 @param locale The locale for instruction. Currently supports "en" and "fa"
 @param completionHandler This handler is called when the process of fetching direction
 * results is completed. The block will be called on the main_queue.
 @see CSRoutePair.h
 */
- (void)calculateDirectionsWithInstructionsForRoutePairs:(nonnull NSArray<CSRoutePair *> *)routePairs locale:(nonnull NSLocale *)locale withCompletionHandler:(nonnull CSDirectionCompletionHandler)completionHandler;

/**
 * This method calculates distance using car profile between a source and a destination.
 *
 * Up to 100 pairs of source and destionation points can be provided to calculate a multiple step routing.
 
 @param routePairs An array of CSRoutePair consisting of source and destination points.
 @param completionHandler This handler is called when the process of fetching distance
 * results is completed. The block will be called on the main_queue.
 @see CSRoutePair.h
 */
- (void)calculateDistance:(nonnull NSArray<CSRoutePair *> *)routePairs withCompletionHandler:(nonnull CSDirectionCompletionHandler)completionHandler;


/**
 This methods creates a snapshot image of a map with provided options.

 @param options The options for creating a map image. Size, Zoom level, Custom markers, etc.
 @param completionHandler This handler is called when the process of fetching the map image is completed. The block will be called on the main_queue.
 */
- (void)createMapSnapshotWithOptions:(nonnull CSMapSnapshotOptions *)options withCompletionHandler:(nonnull CSMapSnapshotCompletionHandler)completionHandler;

@end
