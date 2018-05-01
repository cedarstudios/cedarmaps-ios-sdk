//
//  CSMapView.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/22/17.
//

#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>


/**
 * A subclass of MGLMapView tailored for using with CedarMaps tiles.
 *
 * If you use MGLMapView directly, CedarMaps tiles can't be loaded.
 */
@interface CSMapView : MGLMapView

@end

