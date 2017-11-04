//
//  CSReverseGeocodeResponse.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import <JSONModel/JSONModel.h>
#import "CSReverseGeocodePlacemark.h"

@interface CSReverseGeocodeResponse : JSONModel

@property (nonatomic, strong, nonnull) NSString *status;
@property (nonatomic, strong, nullable) CSReverseGeocodePlacemark<Optional> *result;

@end
