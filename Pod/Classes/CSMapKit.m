//
//  CSMapStyle.m
//  Pods
//
//  Created by Emad A. on 30/01/2015.
//
//

#import "CSMapKit.h"
#import "CSAuthenticationManager.h"

#define HTTP_404_NOT_FOUND      404
#define HTTP_401_NOT_AUTHORIZED 401
#define TOKEN_NOT_PROVIDED @"Token is not provided"
#define TOKEN_NOT_PROVIDED_CODE -68
#define INVALID_CREDINTIAL @"Invalid credential"

#pragma mark - CSQueryParameters Private Interface

@interface CSQueryParameters ()

@property (nonatomic, strong) NSMutableDictionary *params;

@end

#pragma mark - CSDistancePoints Private Interface

@interface CSDistancePoints ()

@property (nonatomic, strong) NSMutableString *pointsDesc;

@end

#pragma mark - CSMapSource Private Interface

@interface CSMapKit ()

@property (nonatomic, copy) NSString *mapID;

@end

#pragma mark - CSMapSource Implementation

@implementation CSMapKit

- (instancetype)initWithMapID:(NSString *)mapID
{
    self = [super init];
    if (self != nil) {
        self.mapID = mapID;
    }
    return self;
}

#pragma mark StyleURL

- (void)styleURLWithCompletion:(void (^) (NSURL *url))completion {
    
    [[CSAuthenticationManager sharedManager] savedAccessToken:^(NSString *token) {
        NSString *tileJSONURLString = [NSString stringWithFormat:@"%@/styles/%@.json", [[CSAuthenticationManager sharedManager] baseURL] , self.mapID];
        if (token && token.length > 0) {
            tileJSONURLString = [tileJSONURLString stringByAppendingFormat:@"?access_token=%@", token];
            
            completion([NSURL URLWithString:tileJSONURLString]);
        } else {
            completion(nil);
        }
    }];
}

#pragma mark Distance

- (void)distanceBetweenPoints:(CSDistancePoints *)points withCompletion:(void (^) (NSArray *results, NSError *error))completion {
    
    NSString *arguments = @"";
    if (points.pointsDesc.length > 0 && [[points.pointsDesc substringFromIndex:points.pointsDesc.length-1] isEqualToString:@"/"]) {
        arguments = [points.pointsDesc substringToIndex:points.pointsDesc.length - 1];
    }
    
    NSMutableString *URLString = [NSMutableString stringWithFormat:@"%@/distance/cedarmaps.driving/%@", [[CSAuthenticationManager sharedManager] baseURL], arguments];
    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [[CSAuthenticationManager sharedManager] savedAccessToken:^(NSString *token) {
        if (token) {
            [request setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
            
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if ([(NSHTTPURLResponse *)response statusCode] == HTTP_401_NOT_AUTHORIZED) {
                    
                    NSString *description = NSLocalizedString(INVALID_CREDINTIAL, @"");
                    NSError *responseError = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorUserCancelledAuthentication userInfo:@{NSLocalizedDescriptionKey: description}];
                    
                    completion(nil, responseError);
                } else {
                    if (error != nil) {
                        completion(nil, error);
                    } else {
                        NSError *serializationError;
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
                        if (serializationError == nil) {
                            NSArray *output = [NSArray array];
                            if ([json.allKeys containsObject:@"result"]) {
                                NSArray *results = [[json objectForKey:@"result"] objectForKey:@"routes"];
                                output = results;
                            }
                            completion(output, nil);
                        }
                        else {
                            completion(nil, serializationError);
                        }
                    }
                }
            }] resume];
        } else {
            NSString *description = NSLocalizedString(TOKEN_NOT_PROVIDED, @"");
            NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:TOKEN_NOT_PROVIDED_CODE userInfo:@{NSLocalizedDescriptionKey: description}];
            completion(nil, error);
        }
    }];
    
}

#pragma mark Geocoding

- (void)forwardGeocodingWithQueryString:(NSString *)query
                             parameters:(CSQueryParameters *)parameters
                             completion:(void (^)(NSArray *results, NSError *error))completion
{
    
    NSMutableString *URLString = [NSMutableString stringWithFormat:@"%@/geocode/%@/%@", [[CSAuthenticationManager sharedManager] baseURL], self.mapID, query];
    if (parameters != nil) {
        [URLString appendString:@"?"];
        [parameters.params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (key > 0) {
                [URLString appendString:@"&"];
            }
            [URLString appendFormat:@"%@=%@", key, obj];
        }];
    }
    
    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [[CSAuthenticationManager sharedManager] savedAccessToken:^(NSString *token) {
        if (token) {
            [request setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
            
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if ([(NSHTTPURLResponse *)response statusCode] == HTTP_401_NOT_AUTHORIZED) {
                    
                    NSString *description = NSLocalizedString(INVALID_CREDINTIAL, @"");
                    NSError *responseError = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorUserCancelledAuthentication userInfo:@{NSLocalizedDescriptionKey: description}];
                    
                    completion(nil, responseError);
                } else {
                    if (error != nil) {
                        completion(nil, error);
                    } else {
                        NSError *serializationError;
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
                        if (serializationError == nil) {
                            NSArray *output = [NSArray array];
                            if ([json.allKeys containsObject:@"results"]) {
                                NSArray *results = [json objectForKey:@"results"];
                                output = results;
                            }
                            completion(output, nil);
                        }
                        else {
                            completion(nil, serializationError);
                        }
                    }
                }
            }] resume];
        } else {
            NSString *description = NSLocalizedString(TOKEN_NOT_PROVIDED, @"");
            NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:TOKEN_NOT_PROVIDED_CODE userInfo:@{NSLocalizedDescriptionKey: description}];
            completion(nil, error);
        }
    }];
    
}

- (void)reverseGeocodingWithCoordinate:(CLLocationCoordinate2D)coordinate
                            completion:(void (^)(NSDictionary *results, NSError *error))completion
{
    NSMutableString *URLString = [NSMutableString stringWithFormat:@"%@/geocode/%@/%@,%@.json",
                                  [[CSAuthenticationManager sharedManager] baseURL], self.mapID, @(coordinate.latitude), @(coordinate.longitude)];
    
    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [[CSAuthenticationManager sharedManager] savedAccessToken:^(NSString *token) {
        if (token) {
            [request setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
            
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if ([(NSHTTPURLResponse *)response statusCode] == HTTP_401_NOT_AUTHORIZED) {
                    
                    NSString *description = NSLocalizedString(INVALID_CREDINTIAL, @"");
                    NSError *responseError = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorUserCancelledAuthentication userInfo:@{NSLocalizedDescriptionKey: description}];
                    
                    completion(nil, responseError);
                } else {
                    if (error != nil) {
                        completion(nil, error);
                    } else {
                        NSError *serializationError;
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
                        if (serializationError == nil) {
                            NSDictionary *output = [NSDictionary dictionary];
                            if ([json.allKeys containsObject:@"result"]) {
                                NSDictionary *result = [json objectForKey:@"result"];
                                output = result;
                            }
                        }
                        else {
                            completion(nil, serializationError);
                        }
                    }
                }
            }] resume];
        } else {
            NSString *description = NSLocalizedString(TOKEN_NOT_PROVIDED, @"");
            NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:TOKEN_NOT_PROVIDED_CODE userInfo:@{NSLocalizedDescriptionKey: description}];
            completion(nil, error);
        }
    }];
}

@end

#pragma mark

@implementation CSQueryParameters

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.params = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)addCity:(NSString *)city
{
    [self.params setObject:city forKey:@"city"];
}

- (void)addLimit:(NSUInteger)limit
{
    [self.params setObject:@(limit) forKey:@"limit"];
}

- (void)addDistance:(CLLocationDistance)distance
{
    [self.params setObject:@(distance) forKey:@"distance"];
}

- (void)addLocationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.params setObject:[NSString stringWithFormat:@"%@,%@", @(coordinate.latitude), @(coordinate.longitude)] forKey:@"location"];
}

@end

#pragma mark

@implementation CSDistancePoints

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.pointsDesc = [NSMutableString string];
    }
    
    return self;
}

- (void)addCoordinatePairWithDeparture:(CLLocationCoordinate2D)departure destination:(CLLocationCoordinate2D)destination {
    
    [self.pointsDesc appendString:[NSString stringWithFormat:@"%f,%f;%f,%f/", departure.latitude, departure.longitude, destination.latitude, destination.longitude]];
}

@end
