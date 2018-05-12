//
//  CSDirectionCompleteResponse.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/25/17.
//

#import <Mantle/Mantle.h>
#import "CSRoute.h"

@interface CSDirectionResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, nonnull) NSString *status;
@property (nonatomic, strong, nullable) NSArray<CSRoute *> *routes;

@end
