//
//  CSReverseGeocodePlacemark.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import <JSONModel/JSONModel.h>

@class CSTrafficZone;
@class CSReverseGeocodeComponent;
@protocol CSReverseGeocodeComponent;


/**
 *  Represents placemark data for a geographic location in a reverse geocode request. Placemark data can be
 *  information such as the province, city, and street address.
 */
@interface CSReverseGeocodePlacemark: JSONModel


/**
 Address for the result.
 */
@property (nonatomic, strong, nullable) NSString<Optional> *address;


/**
 Locality name for the result.
 */
@property (nonatomic, strong, nullable) NSString<Optional> *locality;


/**
 District name for the result.
 */
@property (nonatomic, strong, nullable) NSString<Optional> *district;


/**
 Place name for the result. If it exists.
 */
@property (nonatomic, strong, nullable) NSString<Optional> *place;


/**
 City name for the result.
 */
@property (nonatomic, strong, nullable) NSString<Optional> *city;


/**
 Province name for the result.
 */
@property (nonatomic, strong, nullable) NSString<Optional> *province;


/**
 Traffic zone information for the result.
 */
@property (nonatomic, strong, nullable) CSTrafficZone<Optional> *trafficZone;


/**
 Detailed address components for the result.
 */
@property (nonatomic, strong, nullable) NSArray<CSReverseGeocodeComponent *> <CSReverseGeocodeComponent, Optional> *components;

@end

typedef void (^CSReverseGeocodeCompletionHandler)(CSReverseGeocodePlacemark* __nullable placemark, NSError * __nullable error);


#pragma mark - Traffic Zone

/**
 * Traffic zone information for a Reverse Geocode response
 */
@interface CSTrafficZone: JSONModel


/**
 Name of the Traffic Zone.
 */
@property (nonatomic, strong, nullable) NSString<Optional> *name;


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
@interface CSReverseGeocodeComponent: JSONModel


/**
 Short name of the component for a result
 */
@property (nonatomic, strong, nonnull) NSString<Optional> *shortName;


/**
 Long name of the component for a result
 */
@property (nonatomic, strong, nonnull) NSString<Optional> *longName;


/**
 Type of the component for a result
 */
@property (nonatomic, strong, nonnull) NSString *type;

@end
