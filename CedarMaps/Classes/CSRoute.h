//
//  CSDirectionResponse.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/25/17.
//

#import <Mantle/Mantle.h>
#import "CSBoundingBox.h"
#import "CSRouteInstruction.h"

/**
 * A CSRoute object shows direction and distance information.
 */
@interface CSRoute: MTLModel <MTLJSONSerializing>


/**
 Total distance in a route in meters using car profile.
 */
@property (nonatomic, assign) CLLocationDistance distance;


/**
 ETA for a route in seconds using car profile.
 */
@property (nonatomic, assign) NSTimeInterval time;


/**
 Bounding box for a route.
 */
@property (nonatomic, strong, nonnull) CSBoundingBox *boundingBox;


/**
 The location points which make a route.
 */
@property (nonatomic, strong, nullable) NSArray<CLLocation *> *points;

/**
 * Verbal representation of the route.
 */
@property (nonatomic, strong, nullable) NSArray<CSRouteInstruction *> *instructions;

@end

typedef void (^CSDirectionCompletionHandler)(NSArray<CSRoute *> * __nullable routes, NSError * __nullable error);

