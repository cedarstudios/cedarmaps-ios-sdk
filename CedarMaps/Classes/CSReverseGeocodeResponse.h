//
//  CSReverseGeocodeResponse.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import <Mantle/Mantle.h>
#import "CSReverseGeocodePlacemark.h"

@interface CSReverseGeocodeResponse: MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, nonnull) NSString *status;
@property (nonatomic, strong, nullable) CSReverseGeocodePlacemark *result;

@end
