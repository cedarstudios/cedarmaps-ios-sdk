//
//  CSForwardGeocodePlacemark.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import <JSONModel/JSONModel.h>
#import "CSRegion.h"

@protocol CSForwardGeocodePlacemark;
@class CSForwardGeocodeComponent;

/**
 *  Represents placemark data for a geographic location in a forward geocode request. Placemark data can be
 *  information such as the province, city, and street address.
 */
@interface CSForwardGeocodePlacemark: JSONModel


/**
 The unique identifier for the result.
 */
@property (nonatomic, assign) NSInteger identifier;


/**
 Name of the result.
 */
@property (nonatomic, strong, nonnull) NSString *name;


/**
 English name of the result.
 */
@property (nonatomic, strong, nullable) NSString<Optional> *nameEn;


/**
 Type of the result. e.g. street, locality, place, etc.
 */
@property (nonatomic, strong, nonnull)  NSString *type;


/**
 A simple generated address from components field.
 */
@property (nonatomic, strong, nullable) NSString<Optional> *address;


/**
 Detailed address components for the result.
 */
@property (nonatomic, strong, nonnull) CSForwardGeocodeComponent *components;


/**
 Geometric region of the result.
 */
@property (nonatomic, strong, nullable) CSRegion<Optional> *region;

@end

typedef void (^CSForwardGeocodeCompletionHandler)(NSArray<CSForwardGeocodePlacemark *> * __nullable placemarks, NSError * __nullable error);

typedef NS_OPTIONS(NSUInteger, CSPlacemarkType) {
    CSPlacemarkTypeAll        = 0,
    CSPlacemarkTypeRoundabout = 1 << 0,
    CSPlacemarkTypeStreet     = 1 << 1,
    CSPlacemarkTypeFreeway    = 1 << 2,
    CSPlacemarkTypeExpressway = 1 << 3,
    CSPlacemarkTypeBoulevard  = 1 << 4,
    CSPlacemarkTypeLocality   = 1 << 5,
};
NSString* _Nonnull stringValueForPlacemarkType(CSPlacemarkType type);

#pragma mark Components


/**
 *  Represents placemark components data for a geographic location in a forward geocode request.
 */
@interface CSForwardGeocodeComponent: JSONModel

@property (nonatomic, strong, nullable) NSString<Optional> *country;
@property (nonatomic, strong, nullable) NSString<Optional> *province;
@property (nonatomic, strong, nullable) NSString<Optional> *city;
@property (nonatomic, strong, nullable) NSArray<NSString *> <Optional> *districts;
@property (nonatomic, strong, nullable) NSArray<NSString *> <Optional> *localities;

@end
