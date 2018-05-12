//
//  CSMapSnapshotMarker.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/29/17.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


/**
 Custom markers for drawing on a map snapshot request
 */
@interface CSMapSnapshotMarker : NSObject


/**
 Coordinate of the marker.
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;


/**
 The remote URL of the marker. If nil, the default marker is used.
 */
@property (nonatomic, strong, nullable, readonly) NSURL *url;


/**
 Initializer for creating a marker for using in a map snapshot request.

 @param coordinate Coordinate of the marker.
 @param url The remote url of desired marker image.
 @return An instance of CSMapSnapshotMarker.
 */
- (nonnull instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate markerURL:(nonnull NSURL *)url;

/**
 Initializer for creating a marker with default appearance for using in a map snapshot request.

 @param coordinate Coordinate of the marker.
 @return An instance of CSMapSnapshotMarker.
 */
- (nonnull instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
