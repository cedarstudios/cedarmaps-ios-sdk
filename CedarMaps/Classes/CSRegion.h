//
//  CSRegion.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import <Mantle/Mantle.h>
#import <CoreLocation/CoreLocation.h>
#import "CSBoundingBox.h"

/**
 *
 * Geometric region of a Forward Geocode result.
 */
@interface CSRegion: MTLModel <MTLJSONSerializing>


/**
 *
 * The center location of a Forward Geocode result.
 */
@property (nonatomic, strong, nonnull) CLLocation *center;



/**
 The bounding box of a Forward Geocode result.
 */
@property (nonatomic, strong, nonnull) CSBoundingBox *boundingBox;

@end

