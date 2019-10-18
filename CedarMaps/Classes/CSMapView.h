//
//  CSMapView.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/22/17.
//

#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>

typedef NSString * CSMapViewStyle NS_STRING_ENUM;
static CSMapViewStyle const _Nonnull CSMapViewStyleVectorLight = @"https://api.cedarmaps.com/v1/styles/cedarmaps.light.json";
static CSMapViewStyle const _Nonnull CSMapViewStyleVectorDark = @"https://api.cedarmaps.com/v1/styles/cedarmaps.dark.json";
static CSMapViewStyle const _Nonnull CSMapViewStyleRasterLight = @"https://api.cedarmaps.com/v1/tiles/light.json";

/**
 * A subclass of MGLMapView tailored for using with CedarMaps tiles.
 *
 * If you use MGLMapView directly, CedarMaps tiles can't be loaded.
 */
@interface CSMapView : MGLMapView

@end

