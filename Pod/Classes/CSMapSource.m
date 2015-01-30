//
//  CSMapSource.m
//  Pods
//
//  Created by Emad A. on 30/01/2015.
//
//

#import "CSMapSource.h"

static NSString * const kBaseURL = @"http://maps.cedar.ir/api/v1";

#pragma mark - CSQueryParameters Private Interface
#pragma mark

@interface CSQueryParameters ()

@property (nonatomic, strong) NSMutableDictionary *params;

@end

#pragma mark - CSMapSource Private Interface
#pragma mark

@interface CSMapSource () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *searchStreetURLConnection;
@property (nonatomic, strong) NSMutableData *searchStreetResponseData;
@property (nonatomic, copy) void (^searchStreetCompletion)(NSDictionary *result, NSError *error);

@end

#pragma mark - CSMapSource Implementation
#pragma mark

@implementation CSMapSource

- (void)searchStreetWithQueryString:(NSString *)query
                         parameters:(CSQueryParameters *)parameters
                         completion:(void (^)(NSDictionary *, NSError *))completion
{
    self.searchStreetCompletion = completion;

    NSMutableString *URLString = [NSMutableString stringWithFormat:@"%@/street/search?q=%@", kBaseURL, query];
    if (parameters != nil) {
        [parameters.params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [URLString appendFormat:@"&%@=%@", key, obj];
        }];
    }

    [URLString appendFormat:@"&key=%@", @"emad"];

    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    if (self.searchStreetURLConnection != nil) {
        [self.searchStreetURLConnection cancel];
    }

    self.searchStreetURLConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.searchStreetResponseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.searchStreetResponseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.searchStreetResponseData options:0 error:&error];
    if (error == nil && self.searchStreetCompletion != nil) {
        self.searchStreetCompletion(json, nil);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.searchStreetCompletion != nil) {
        self.searchStreetCompletion(nil, error);
    }
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

- (void)addDistance:(CGFloat)distance
{
    [self.params setObject:@(distance) forKey:@"distance"];
}

- (void)addLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    [self.params setObject:[NSString stringWithFormat:@"%@,%@", @(latitude), @(longitude)] forKey:@"location"];
}

@end
