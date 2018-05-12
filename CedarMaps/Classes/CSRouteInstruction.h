//
//  CSRouteInstruction.h
//  CedarMaps
//
//  Created by Saeed Taheri on 1/13/18.
//

#import <Mantle/Mantle.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, CSInstructionSign) {
    CSInstructionSignKeepLeft = -7,
    CSInstructionSignTurnSharpLeft = -3,
    CSInstructionSignTurnLeft = -2,
    CSInstructionSignTurnSlightLeft = -1,
    CSInstructionSignContinue = 0,
    CSInstructionSignTurnSlightRight = 1,
    CSInstructionSignTurnRight = 2,
    CSInstructionSignTurnSharpRight = 3,
    CSInstructionSignFinish = 4,
    CSInstructionSignReachedVia = 5,
    CSInstructionSignUseRoundabout = 6,
    CSInstructionSignKeepRight = 7
};

/**
 * Verbal representation of a route section in routing.
 */
@interface CSRouteInstruction: MTLModel <MTLJSONSerializing>

/**
 Distance in a route section in meters using car profile.
 */
@property (nonatomic, assign) CLLocationDistance distance;

/**
 ETA for a route in seconds using car profile.
 */
@property (nonatomic, assign) NSTimeInterval time;

/**
 Main street name in the route section.
 */
@property (nonatomic, strong) NSString *streetName;

/**
 Textual instruction of route section.
 */
@property (nonatomic, strong) NSString *text;

/**
 An array of indeces; these indeces can be looked up in CSRoute `points` property. It shows locations included in this section.
 */
@property (nonatomic, strong) NSArray<NSNumber *> *interval;

/**
 Traffic sign of current section.
 */
@property (nonatomic, assign) CSInstructionSign sign;

@end
