//
//  CSError.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import <Foundation/Foundation.h>

#define CEDARMAPS_RESPONSE_PARSING_ERROR @"Response Parsing Error"
#define CEDARMAPS_UNKNOWN_ERROR @"Unknown Error"

@interface CSError : NSError

+ (nonnull NSError *)errorWithDescription:(nonnull NSString *)errorDescription;

@end
