//
//  CSForwardGeocodeResponse.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import <Mantle/Mantle.h>
#import "CSForwardGeocodePlacemark.h"

@interface CSForwardGeocodeResponse: MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, nonnull) NSString *status;
@property (nonatomic, strong, nullable) NSArray<CSForwardGeocodePlacemark *> *results;

@end
