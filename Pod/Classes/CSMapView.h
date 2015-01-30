//
//  CSMapSample.h
//  Pods
//
//  Created by Emad A. on 19/01/2015.
//
//

#import <Foundation/Foundation.h>
#import "CSMapSource.h"
#import "Mapbox.h"

@interface CSMapView : RMMapView

@property (nonatomic, assign) BOOL showLogoBug      __attribute__((unavailable));
@property (nonatomic, assign) BOOL hideAttribution  __attribute__((unavailable));

@end
