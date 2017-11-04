//
//  CSDirectionCompleteResponse.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/25/17.
//

#import <JSONModel/JSONModel.h>
#import "CSRoute.h"

@interface CSDirectionResponse : JSONModel

@property (nonatomic, strong, nonnull) NSString *status;
@property (nonatomic, strong, nullable) NSArray<CSRoute *> <CSRoute, Optional> *routes;

@end
