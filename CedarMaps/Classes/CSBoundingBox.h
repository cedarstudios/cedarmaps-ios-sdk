//
//  CSBoundingBox.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import <CoreLocation/CoreLocation.h>

/**
 * The class used for creating a rectangular region bu specifying south west and north east coordinates.
 */
@interface CSBoundingBox: MTLModel <MTLJSONSerializing>


/**
 * The north east location of the bounding box
 */
@property (nonatomic, strong, nonnull) CLLocation *northEast;


/**
 * The south west location of the bounding box
 */
@property (nonatomic, strong, nonnull) CLLocation *southWest;



/**
 The designated initializer to use for creating a CSBoundingBox instance.

 @param northEast The north east coordinate of the bounding box
 @param southWest The south west coordinate of the bounding box
 @return An instance of a CSBoundingBox object
 */
- (nonnull instancetype)initWithNorthEastCoordinate:(CLLocationCoordinate2D)northEast southWestCoordinate:(CLLocationCoordinate2D)southWest;

@end

