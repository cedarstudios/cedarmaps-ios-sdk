//
//  CSForwardGeocodeResponse.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import <JSONModel/JSONModel.h>
#import "CSForwardGeocodePlacemark.h"

@interface CSForwardGeocodeResponse : JSONModel

@property (nonatomic, strong, nonnull) NSString *status;
@property (nonatomic, strong, nullable) NSArray<CSForwardGeocodePlacemark *> <CSForwardGeocodePlacemark, Optional> *results;

@end
