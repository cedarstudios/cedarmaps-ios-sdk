//
//  CSMapSnapshotOptions.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/29/17.
//

#import <Foundation/Foundation.h>
#import "CSMapSnapshotMarker.h"
#import <CoreLocation/CoreLocation.h>


/**
 The options for customizing a map snapshot request.
 */
@interface CSMapSnapshotOptions : NSObject


/**
 Desired size of the map image in points.
 */
@property (nonatomic, assign) CGSize size;


/**
 Desired zoom level of the map.
 */
@property (nonatomic, assign) NSInteger zoomLevel;


/**
 Center location of the map.
 */
@property (nonatomic, strong, nullable) CLLocation *center;


/**
 Custom markers to draw on map snapshot.
 */
@property (nonatomic, strong, nullable) NSArray<CSMapSnapshotMarker *> *markers;

@end
