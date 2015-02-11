//
//  CSMapSource.m
//  Pods
//
//  Created by Emad A. on 30/01/2015.
//
//

#import "CSMapSource.h"
#import "CSAuthenticationManager.h"

#define HTTP_404_NOT_FOUND      404
#define HTTP_401_NOT_AUTHORIZED 401

static NSString * const kBaseURL = @"http://api.cedarmaps.com/v1";

#pragma mark - CSQueryParameters Private Interface
#pragma mark

@interface CSQueryParameters ()

@property (nonatomic, strong) NSMutableDictionary *params;

@end

#pragma mark - CSMapSource Private Interface
#pragma mark

@interface CSMapSource () <NSURLConnectionDataDelegate>

@property (nonatomic, assign) NSInteger try;
@property (nonatomic, copy) NSString *mapId;
@property (nonatomic, strong) NSDictionary *info;

@property (nonatomic, strong) NSURLConnection *forwardGeocodingURLConnection;
@property (nonatomic, strong) NSMutableData *forwardGeocodingResponseData;
@property (nonatomic, copy) void (^forwardGeocodingCompletion)(NSArray *results, NSError *error);

@property (nonatomic, strong) NSURLConnection *reverseGeocodingURLConnection;
@property (nonatomic, strong) NSMutableData *reverseGeocodingResponseData;
@property (nonatomic, copy) void (^reverseGeocodingCompletion)(NSDictionary *result, NSError *error);

@end

#pragma mark - CSMapSource Implementation
#pragma mark

@implementation CSMapSource

- (id)initWithMapId:(NSString *)mapId
{
    return [self initWithMapId:mapId enablingDataOnMapView:nil];
}

- (id)initWithMapId:(NSString *)mapId enablingDataOnMapView:(RMMapView *)mapView
{
    self = [super init];
    if (self != nil) {
        self.mapId = mapId;

        if (mapView != nil) {
            mapView.tileSource = self;
        }
    }

    return self;
}

- (NSURL *)URLForTile:(RMTile)tile
{
    NSNumber *x = [NSNumber numberWithInteger:tile.x];
    NSNumber *y = [NSNumber numberWithInteger:tile.y];
    NSNumber *z = [NSNumber numberWithInteger:tile.zoom];

    if (!self.info && ![self loadTileJSON]) {
        return nil;
    }

    NSString *tileURLString = [self.info objectForKey:@"tiles"][0];
    tileURLString = [tileURLString stringByReplacingOccurrencesOfString:@"{z}" withString:z.stringValue];
    tileURLString = [tileURLString stringByReplacingOccurrencesOfString:@"{x}" withString:x.stringValue];
    tileURLString = [tileURLString stringByReplacingOccurrencesOfString:@"{y}" withString:y.stringValue];

    if ([[UIScreen mainScreen] scale] > 1.0) {
        tileURLString = [tileURLString stringByReplacingOccurrencesOfString:@".png" withString:@"@2x.png"];
    }

    return [NSURL URLWithString:tileURLString];
}

- (UIImage*)imageForTile:(RMTile)tile inCache:(RMTileCache *)tileCache
{
    __block UIImage *image = nil;

    tile = [[self mercatorToTileProjection] normaliseTile:tile];

    if (self.isCacheable) {
        image = [tileCache cachedImage:tile withCacheKey:[self uniqueTilecacheKey]];
        if (image != nil) {
            return image;
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^(void) {
       [[NSNotificationCenter defaultCenter] postNotificationName:RMTileRequested object:[NSNumber numberWithUnsignedLongLong:RMTileKey(tile)]];
    });

    NSURL *URL = [self URLForTile:tile];

    for (NSUInteger try = 0; URL != nil && image == nil && try < self.retryCount; ++try) {
        NSError *error = nil;
        NSHTTPURLResponse *response = nil;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setTimeoutInterval:(self.requestTimeoutSeconds / (CGFloat)self.retryCount)];
        image = [UIImage imageWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]];

        if (response.statusCode == HTTP_404_NOT_FOUND) {
            break;
        }
        else if (error.code == kCFURLErrorUserCancelledAuthentication) {
            // Invalidating access token and tile json info in order to them again in next request
            [[CSAuthenticationManager sharedManager] invalidateCredential];
            [self setInfo:nil];

            // Return NSNull here so that the RMMapTiledLayerView will try to fetch another tile if missingTilesDepth > 0
            image = (UIImage *)[NSNull null];

            break;
        }
    }

    if (image && ![image isKindOfClass:[NSNull class]] && self.isCacheable) {
        [tileCache addImage:image forTile:tile withCacheKey:[self uniqueTilecacheKey]];
    }

    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RMTileRetrieved object:[NSNumber numberWithUnsignedLongLong:RMTileKey(tile)]];
    });
    
    return image;
}

#pragma mark

- (BOOL)loadTileJSON
{
    NSString *tileJSONURLString = [NSString stringWithFormat:@"%@/tiles/%@.json", kBaseURL, self.mapId];
    tileJSONURLString = [tileJSONURLString stringByAppendingFormat:@"?access_token=%@", [[CSAuthenticationManager sharedManager] accessToken]];

    NSError *error = nil;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:tileJSONURLString]
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:5];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];

    if (error == nil) {
        NSError *error = nil;
        self.info = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error != nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CSMapSourceErrorNotification
                                                                object:self
                                                              userInfo:@{@"error":error}];
            return NO;
        }
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:CSMapSourceErrorNotification
                                                            object:self
                                                          userInfo:@{@"error":error}];
        return NO;
    }

    return YES;
}

#pragma mark

- (void)forwardGeocodingWithQueryString:(NSString *)query
                             parameters:(CSQueryParameters *)parameters
                             completion:(void (^)(NSArray *, NSError *))completion
{
    self.forwardGeocodingCompletion = completion;

    NSMutableString *URLString = [NSMutableString stringWithFormat:@"%@/geocode/%@/%@.json", kBaseURL, self.mapId, query];
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
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [[CSAuthenticationManager sharedManager] accessToken]] forHTTPHeaderField:@"Authorization"];

    if (self.forwardGeocodingURLConnection != nil) {
        [self.forwardGeocodingURLConnection cancel];
    }

    self.forwardGeocodingURLConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)reverseGeocodingWithCoordinate:(CLLocationCoordinate2D)coordinate
                            completion:(void (^)(NSDictionary *, NSError *))completion
{
    self.reverseGeocodingCompletion = completion;

    NSMutableString *URLString = [NSMutableString stringWithFormat:@"%@/geocode/%@/%@,%@.json",
                                  kBaseURL, self.mapId, @(coordinate.latitude), @(coordinate.longitude)];

    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [[CSAuthenticationManager sharedManager] accessToken]] forHTTPHeaderField:@"Authorization"];

    if (self.reverseGeocodingURLConnection != nil) {
        [self.reverseGeocodingURLConnection cancel];
    }

    self.reverseGeocodingURLConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSError *error = nil;
    if ([(NSHTTPURLResponse *)response statusCode] == HTTP_401_NOT_AUTHORIZED) {
        [connection cancel];
        error = [NSError errorWithDomain:@"Invalid credential" code:kCFURLErrorUserCancelledAuthentication userInfo:nil];
        if ([connection isEqual:self.forwardGeocodingURLConnection]) {
            self.forwardGeocodingCompletion(nil, error);
        }
        else if ([connection isEqual:self.reverseGeocodingURLConnection]) {
            self.reverseGeocodingCompletion(nil, error);
        }
    }
    else {

        if ([connection isEqual:self.forwardGeocodingURLConnection]) {
            self.forwardGeocodingResponseData = [[NSMutableData alloc] init];
        }
        else if ([connection isEqual:self.reverseGeocodingURLConnection]) {
            self.reverseGeocodingResponseData = [[NSMutableData alloc] init];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ([connection isEqual:self.forwardGeocodingURLConnection]) {
        [self.forwardGeocodingResponseData appendData:data];
    }
    else if ([connection isEqual:self.reverseGeocodingURLConnection]) {
        [self.reverseGeocodingResponseData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    self.try = 0;

    if ([connection isEqual:self.forwardGeocodingURLConnection]) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.forwardGeocodingResponseData options:0 error:&error];
        if (error == nil && self.forwardGeocodingCompletion != nil) {
            NSArray *output = [NSArray array];
            if ([json.allKeys containsObject:@"results"]) {
                NSArray *results = [json objectForKey:@"results"];
                output = results;
            }
            self.forwardGeocodingCompletion(output, nil);
        }
        else {
            self.forwardGeocodingCompletion(nil, error);
        }
    }
    else if ([connection isEqual:self.reverseGeocodingURLConnection]) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.reverseGeocodingResponseData options:0 error:&error];
        if (error == nil && self.reverseGeocodingCompletion != nil) {
            NSDictionary *output = [NSDictionary dictionary];
            if ([json.allKeys containsObject:@"result"]) {
                NSDictionary *result = [json objectForKey:@"result"];
                output = result;
            }
            self.reverseGeocodingCompletion(output, nil);
        }
        else {
            self.reverseGeocodingCompletion(nil, error);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([connection isEqual:self.forwardGeocodingURLConnection] &&
        self.forwardGeocodingCompletion != nil)
    {
        self.forwardGeocodingCompletion(nil, error);
    }
    else if ([connection isEqual:self.reverseGeocodingURLConnection] &&
        self.reverseGeocodingCompletion != nil)
    {
        self.reverseGeocodingCompletion(nil, error);
    }
}

#pragma mark

- (float)maxZoom
{
    return [self.info[@"MaxZoom"] floatValue] ?: 17;
}

- (float)minZoom
{
    return [self.info[@"minZoom"] floatValue] ?: 11;
}

- (RMSphericalTrapezium)bounds
{
    NSArray *infoBounds = self.info[@"bounds"];

    RMSphericalTrapezium bounds;
    bounds.northEast = CLLocationCoordinate2DMake([infoBounds[0] doubleValue], [infoBounds[1] doubleValue]);
    bounds.northEast = CLLocationCoordinate2DMake([infoBounds[2] doubleValue], [infoBounds[3] doubleValue]);

    return bounds;
}

- (NSString *)uniqueTilecacheKey
{
    return @"CedarStudioMap";
}

- (NSString *)shortName
{
    return @"CedarMaps Streets";
}

- (NSString *)longDescription
{
    return @"CedarMaps covering the city of Tehran";
}

- (NSString *)shortAttribution
{
    return @"© Cedar Studio Map";
}

- (NSString *)longAttribution
{
    return @"Map data © Cedar Studio Map";
}

- (NSString *)version
{
    return self.info[@"version"];
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
