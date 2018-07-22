//
//  CSForwardGeocodePlacemark.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import <Mantle/Mantle.h>
#import "CSRegion.h"

#pragma mark Components

/**
 *  Represents placemark components data for a geographic location in a forward geocode request.
 */
@interface CSForwardGeocodeComponent: MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, nullable) NSString *country;
@property (nonatomic, strong, nullable) NSString *province;
@property (nonatomic, strong, nullable) NSString *city;
@property (nonatomic, strong, nullable) NSArray<NSString *> *districts;
@property (nonatomic, strong, nullable) NSArray<NSString *> *localities;

@end

#pragma mark CSForwardGeocodePlacemark

/**
 *  Represents placemark data for a geographic location in a forward geocode request. Placemark data can be
 *  information such as the province, city, and street address.
 */
@interface CSForwardGeocodePlacemark: MTLModel <MTLJSONSerializing>


/**
 The unique identifier for the result.
 */
@property (nonatomic, assign) NSInteger identifier;


/**
 Name of the result.
 */
@property (nonatomic, strong, nonnull) NSString *name;

/**
 Alternate name of the result. e.g Jordan, Africa
 */
@property (nonatomic, strong, nonnull) NSString *alternateName;

/**
 English name of the result.
 */
@property (nonatomic, strong, nullable) NSString *nameEn;


/**
 Type of the result. e.g. street, locality, place, etc.
 */
@property (nonatomic, strong, nonnull)  NSString *type;

/**
 Category of the result in case its type is poi.
 */
@property (nonatomic, strong, nullable)  NSString *category;

/**
 Kikojas slug of the result in case its type is poi.
 */
@property (nonatomic, strong, nullable)  NSString *slug;


/**
 A simple generated address from components field.
 */
@property (nonatomic, strong, nullable) NSString *address;


/**
 Detailed address components for the result.
 */
@property (nonatomic, strong, nonnull) CSForwardGeocodeComponent *components;


/**
 Geometric region of the result.
 */
@property (nonatomic, strong, nullable) CSRegion *region;

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
    CSPlacemarkTypePOI        = 1 << 6
};
NSString* _Nonnull stringValueForPlacemarkType(CSPlacemarkType type);
