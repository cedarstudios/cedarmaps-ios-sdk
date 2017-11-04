//
//  CSRegion.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import <JSONModel/JSONModel.h>
#import "CSBoundingBox.h"
@import CoreLocation;


/**
 *
 * Geometric region of a Forward Geocode result.
 */
@interface CSRegion: JSONModel


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

