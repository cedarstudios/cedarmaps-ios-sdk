//
//  CSRoutePair.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/25/17.
//

#import <Foundation/Foundation.h>
@import CoreLocation;


/**
 A wrapper class consisting of a source and a destination for using in a Directions or Distance request.
 */
@interface CSRoutePair : NSObject


/**
 Source location of the route.
 */
@property (nonatomic, strong, nonnull) CLLocation *source;


/**
 Destination location for the route.
 */
@property (nonatomic, strong, nonnull) CLLocation *destination;


/**
 Designated initializer for creating a CSRoutePair.

 @param source Source location of the route.
 @param destination Destination location of the route.
 @return An instance of CSRoutePair object.
 */
- (nonnull instancetype)initWithSource:(nonnull CLLocation *)source destination:(nonnull CLLocation *)destination;

@end
