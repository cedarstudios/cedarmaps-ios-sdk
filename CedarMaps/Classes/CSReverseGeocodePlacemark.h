//
//  CSReverseGeocodePlacemark.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import <Mantle/Mantle.h>

@class CSTrafficZone;
@class CSReverseGeocodeComponent;

/**
 *  Represents placemark data for a geographic location in a reverse geocode request. Placemark data can be
 *  information such as the province, city, and street address.
 */
@interface CSReverseGeocodePlacemark: MTLModel <MTLJSONSerializing>


/**
 Address for the result.
 */
@property (nonatomic, strong, nullable) NSString *address;


/**
 Locality name for the result.
 */
@property (nonatomic, strong, nullable) NSString *locality;


/**
 District name for the result.
 */
@property (nonatomic, strong, nullable) NSString *district;


/**
 Place name for the result. If it exists.
 */
@property (nonatomic, strong, nullable) NSString *place;


/**
 City name for the result.
 */
@property (nonatomic, strong, nullable) NSString *city;


/**
 Province name for the result.
 */
@property (nonatomic, strong, nullable) NSString *province;


/**
 Traffic zone information for the result.
 */
@property (nonatomic, strong, nullable) CSTrafficZone *trafficZone;


/**
 Detailed address components for the result.
 */
@property (nonatomic, strong, nullable) NSArray<CSReverseGeocodeComponent *> *components;

@end

typedef void (^CSReverseGeocodeCompletionHandler)(CSReverseGeocodePlacemark* __nullable placemark, NSError * __nullable error);


#pragma mark - Traffic Zone

/**
 * Traffic zone information for a Reverse Geocode response
 */
@interface CSTrafficZone: MTLModel <MTLJSONSerializing>


/**
 Name of the Traffic Zone.
 */
@property (nonatomic, strong, nullable) NSString *name;


/**
 Shows if the location is in Central Traffic Zone.
 */
@property (nonatomic, assign, getter=isInCentral) BOOL inCentral;


/**
 Shows if the location is in Even/Odd Traffic Zone.
 */
@property (nonatomic, assign, getter=isInEvenOdd) BOOL inEvenOdd;

@end

#pragma mark - Components

/**
 * Detailed components of a Reverse Geocode response
 */
@interface CSReverseGeocodeComponent: MTLModel <MTLJSONSerializing>


/**
 Short name of the component for a result
 */
@property (nonatomic, strong, nonnull) NSString *shortName;


/**
 Long name of the component for a result
 */
@property (nonatomic, strong, nonnull) NSString *longName;


/**
 Type of the component for a result
 */
@property (nonatomic, strong, nonnull) NSString *type;

@end
