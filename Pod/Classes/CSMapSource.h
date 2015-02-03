//
//  CSMapSource.h
//  Pods
//
//  Created by Emad A. on 30/01/2015.
//
//

#import "RMMapboxSource.h"

@class CSQueryParameters;

@interface CSMapSource : RMAbstractWebMapSource

- (void)searchStreetWithQueryString:(NSString *)query
                         parameters:(CSQueryParameters *)parameters
                         completion:(void (^)(NSDictionary *result, NSError *error))completion;

@end

#pragma mark

@interface CSQueryParameters : NSObject

- (void)addCity:(NSString *)city;
- (void)addLimit:(NSUInteger)limit;
- (void)addDistance:(CGFloat)distance;
- (void)addLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

@end