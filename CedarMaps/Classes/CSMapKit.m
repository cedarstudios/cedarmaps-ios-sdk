#import <Mapbox/Mapbox.h>
#import "CSMapKit.h"
#import "CSError.h"
#import "CSAuthenticationManager.h"
#import "CSReverseGeocodeResponse.h"
#import "CSForwardGeocodeResponse.h"
#import "CSDirectionResponse.h"
#import <sys/utsname.h>
#import <TargetConditionals.h>

typedef void (^CSNetworkResponseCompletionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

@interface CSMapKit ()

@property (nonatomic, strong, nonnull) NSString *directionProfile;
@property (nonatomic, strong, nonnull) NSString *userAgent;

@end

@implementation CSMapKit

#pragma mark - Initialization

+ (instancetype)sharedMapKit {
	static id _sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[self alloc] init];
	});

	return _sharedInstance;
}

+ (NSURLSession *)sharedURLSession {
	static id _sharedSession = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		configuration.HTTPAdditionalHeaders = @{@"User-Agent": [[CSMapKit sharedMapKit] userAgent]};
		_sharedSession = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
	});

	return _sharedSession;
}

- (NSString *)userAgent {
	if (!_userAgent) {
		NSMutableArray<NSString *> *components = [[NSMutableArray alloc] init];

		NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
		if (!appName) {
			appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
		}
		if (appName) {
			NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
			if (!version) {
				version = @"";
			}
			NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
			if (!build) {
				build = @"";
			}
			[components addObject:[NSString stringWithFormat:@"%@/%@(%@)", appName, version, build]];
		}

		NSString *locale = [[NSLocale preferredLanguages] firstObject];
		if (locale) {
			[components addObject:locale];
		}

		NSString *system;
#if TARGET_OS_SIMULATOR
		system = @"Simulator";
#elif TARGET_OS_IOS
		system = @"iOS";
#elif TARGET_OS_WATCH
		system = @"watchOS";
#elif TARGET_OS_TV
		system = @"tvOS";
#elif TARGET_OS_UNIX
		system = @"Unix";
#elif TARGET_OS_MAC
		system = @"macOS"
#else
		system = @"Unknown";
#endif

		NSOperatingSystemVersion systemVersion = [[[NSProcessInfo alloc] init] operatingSystemVersion];
		[components addObject:[NSString stringWithFormat:@"%@/%li.%li.%li", system, (long)systemVersion.majorVersion, (long)systemVersion.minorVersion, (long)systemVersion.patchVersion]];

		struct utsname systemInfo;
		uname(&systemInfo);
		NSString *identifier = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
		[components addObject:identifier];

		NSString *chip;
#if TARGET_CPU_X86_64
		chip = @"x86_64";
#elif TARGET_CPU_X86
		chip = @"i386";
#elif TARGET_CPU_ARM
		chip = @"arm";
#elif TARGET_CPU_ARM64
		chip = @"arm64";
#else
		chip = @"Unknown";
#endif
		[components addObject:[NSString stringWithFormat:@"(%@)", chip]];

		_userAgent = [components componentsJoinedByString:@" "];
	}

	return _userAgent;
}

- (void)setCredentialsWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret {
	[[CSAuthenticationManager sharedAuthenticationManager] setCredentialsWithClientID:clientID clientSecret:clientSecret];
}

- (void)setAPIBaseURL:(nullable NSString*)urlString {
	[CSAuthenticationManager.sharedAuthenticationManager setBaseURL:urlString];
}

- (void)prepareMapTiles:(void (^)(BOOL, NSError * _Nullable))completion {
	[CSAuthenticationManager.sharedAuthenticationManager accessToken:^(NSString * _Nullable token, NSError * _Nullable error) {

		if (token != nil) {
			[MGLAccountManager setAccessToken:token];
			if (completion != nil) {
				completion(YES, nil);
			}
		} else {
			if (completion != nil) {
				completion(NO, error);
			}
		}
	}];
}

- (NSString *)mapID {
	if (!_mapID) {
		_mapID = @"cedarmaps.streets";
	}
	return _mapID;
}

- (CSMapIndex)mapIndex {
	if (!_mapIndex) {
		_mapIndex = CSMapIndexStreets;
	}
	return _mapIndex;
}

- (NSString *)directionProfile {
	if (!_directionProfile) {
		_directionProfile = @"cedarmaps.driving";
	}
	return _directionProfile;
}

#pragma mark - Network Request

- (void)responseFromURLString:(nonnull NSString *)urlString completionHandler:(nonnull CSNetworkResponseCompletionHandler)completionHandler {
	[CSAuthenticationManager.sharedAuthenticationManager accessToken:^(NSString * _Nullable token, NSError * _Nullable error) {

		if (error != nil) {
			completionHandler(nil, nil, error);
		} else {
			NSString *encodedURLStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

			NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:encodedURLStr]];
			request.timeoutInterval = 10.0;
			[request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];

			[[[CSMapKit sharedURLSession]
			  dataTaskWithRequest:request
			  completionHandler:completionHandler] resume];
		}
	}];
}

- (void)handleHTTPErrorsForResponse:(nullable NSURLResponse *)response {
	if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
		return;
	}
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	switch (httpResponse.statusCode) {
		case 400:
			NSLog(@"Response: %@\nError: %@", response, [CSError errorWithDescription:@"Invalid Request. Missing Parameters."]);
			break;
		case 401:
			[[CSAuthenticationManager sharedAuthenticationManager] refetchAccessToken];
			NSLog(@"Response: %@\nError: %@", response, [CSError errorWithDescription:@"Obtaining Bearer Token Failed."]);
			break;
		case 500:
			NSLog(@"Response: %@\nError: %@", response, [CSError errorWithDescription:@"Internal Server Error."]);
			break;

		default:
			break;
	}
}

#pragma mark - Reverse Geocoding

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CSReverseGeocodeCompletionHandler)completionHandler {

	[self reverseGeocodeLocation:location addressFormat:nil formattedAddressPrefixLength:CSReverseGeocodeFormattedAddressPrefixLengthShort formattedAddressSeparator:nil formattedAddressVerbosity:NO completionHandler:completionHandler];
}

- (void)reverseGeocodeLocation:(CLLocation *)location
				 addressFormat:(NSString *)addressFormat
  formattedAddressPrefixLength:(CSReverseGeocodeFormattedAddressPrefixLength)formattedAddressPrefixLength
	 formattedAddressSeparator:(NSString *)separator
	 formattedAddressVerbosity:(BOOL)shouldOutputVerboseFormattedAddress
			 completionHandler:(CSReverseGeocodeCompletionHandler)completionHandler {
	
	NSString *urlStr = [NSString stringWithFormat:@"%@geocode/%@/%f,%f.json?prefix=%@",
						[CSAuthenticationManager.sharedAuthenticationManager baseURL],
						self.mapIndex,
						location.coordinate.latitude,
						location.coordinate.longitude,
						formattedAddressPrefixLength
						];

	if (addressFormat && addressFormat.length > 0) {
		urlStr = [urlStr stringByAppendingFormat:@"&format=%@", addressFormat];
	}

	if (separator) {
		urlStr = [urlStr stringByAppendingFormat:@"&separator=%@", separator];
	}

	if (shouldOutputVerboseFormattedAddress) {
		urlStr = [urlStr stringByAppendingFormat:@"&verbosity=%@", @"true"];
	}
	
	__weak CSMapKit *weakSelf = self;
	[self responseFromURLString:urlStr completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		[weakSelf handleHTTPErrorsForResponse:response];

		if (error != nil) {
			completionHandler(nil, error);
			return;
		} else if (data != nil) {
			NSError *parsingError;

			NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
			if (parsingError != nil) {
				completionHandler(nil, parsingError);
				return;
			}

			CSReverseGeocodeResponse *reverseGeocodeResponse = [MTLJSONAdapter modelOfClass:CSReverseGeocodeResponse.class fromJSONDictionary:dict error:&parsingError];

			if (parsingError != nil) {
				completionHandler(nil, parsingError);
				return;
			} else if (reverseGeocodeResponse != nil) {
				if ([reverseGeocodeResponse.status isEqualToString:@"OK"]) {
					completionHandler(reverseGeocodeResponse.result, nil);
				} else {
					completionHandler(nil, [CSError errorWithDescription:reverseGeocodeResponse.status]);
				}
				return;
			}
		}
		completionHandler(nil, [CSError errorWithDescription:CEDARMAPS_UNKNOWN_ERROR]);
	}];
}

#pragma mark - Forward Geocoding

- (void)geocodeAddressString:(NSString *)addressString
		   completionHandler:(CSForwardGeocodeCompletionHandler)completionHandler {
	[self geocodeAddressString:addressString withType:CSPlacemarkTypeAll limit:30 customParameters:nil completionHandler:completionHandler];
}

- (void)geocodeAddressString:(NSString *)addressString
					withType:(CSPlacemarkType)type
					   limit:(NSInteger)limit
		   completionHandler:(CSForwardGeocodeCompletionHandler)completionHandler {
	[self geocodeAddressString:addressString withType:type limit:limit customParameters:nil completionHandler:completionHandler];
}

- (void)geocodeAddressString:(NSString *)addressString
					inRegion:(CLCircularRegion *)region
		   completionHandler:(CSForwardGeocodeCompletionHandler)completionHandler {
	[self geocodeAddressString:addressString inRegion:region withType:CSPlacemarkTypeAll limit:30 completionHandler:completionHandler];
}

- (void)geocodeAddressString:(nonnull NSString *)addressString
					withType:(CSPlacemarkType)type
					   limit:(NSInteger)limit
			customParameters:(nullable NSDictionary<NSString *, NSString *> *)parameters
		   completionHandler:(nonnull CSForwardGeocodeCompletionHandler)completionHandler {

	if (addressString.length == 0) {
		completionHandler(nil, [CSError errorWithDescription:@"Empty input"]);
		return;
	}
	int limitParam = MIN(MAX((int)limit, 1), 30);

	__block NSString *urlStr = [NSString stringWithFormat:@"%@geocode/%@/%@?limit=%i",
								[CSAuthenticationManager.sharedAuthenticationManager baseURL],
								self.mapIndex,
								addressString,
								limitParam];

	NSString *typeParam = stringValueForPlacemarkType(type);
	if (typeParam.length > 0) {
		urlStr = [urlStr stringByAppendingFormat:@"&type=%@", typeParam];
	}

	[parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
		urlStr = [urlStr stringByAppendingFormat:@"&%@=%@", key, obj];
	}];

	[self parseGeocodingResponseForURLString:urlStr completionHandler:completionHandler];
}

- (void)geocodeAddressString:(NSString *)addressString
					inRegion:(CLCircularRegion *)region
					withType:(CSPlacemarkType)type
					   limit:(NSInteger)limit
		   completionHandler:(CSForwardGeocodeCompletionHandler)completionHandler {

	if (addressString.length == 0) {
		completionHandler(nil, [CSError errorWithDescription:@"Empty input"]);
		return;
	}

	int limitParam = MIN(MAX((int)limit, 1), 30);

	NSString *urlStr = [NSString stringWithFormat:@"%@geocode/%@/%@?limit=%i&location=%f,%f&distance=%f",
						[CSAuthenticationManager.sharedAuthenticationManager baseURL],
						self.mapIndex,
						addressString,
						limitParam,
						region.center.latitude,
						region.center.longitude,
						region.radius / 1000.0];

	NSString *typeParam = stringValueForPlacemarkType(type);
	if (typeParam.length > 0) {
		urlStr = [urlStr stringByAppendingFormat:@"&type=%@", typeParam];
	}

	[self parseGeocodingResponseForURLString:urlStr completionHandler:completionHandler];
}

- (void)geocodeAddressString:(NSString *)addressString
			   inBoundingBox:(CSBoundingBox *)boundingBox
		   completionHandler:(CSForwardGeocodeCompletionHandler)completionHandler {
	[self geocodeAddressString:addressString inBoundingBox:boundingBox withType:CSPlacemarkTypeAll limit:30 completionHandler:completionHandler];
}

- (void)geocodeAddressString:(NSString *)addressString
			   inBoundingBox:(CSBoundingBox *)boundingBox
					withType:(CSPlacemarkType)type
					   limit:(NSInteger)limit
		   completionHandler:(CSForwardGeocodeCompletionHandler)completionHandler {

	if (addressString.length == 0) {
		completionHandler(nil, [CSError errorWithDescription:@"Empty input"]);
		return;
	}

	int limitParam = MIN(MAX((int)limit, 1), 30);

	NSString *urlStr = [NSString stringWithFormat:@"%@geocode/%@/%@?limit=%i&ne=%f,%f&sw=%f,%f",
						[CSAuthenticationManager.sharedAuthenticationManager baseURL],
						self.mapIndex,
						addressString,
						limitParam,
						boundingBox.northEast.coordinate.latitude,
						boundingBox.northEast.coordinate.longitude,
						boundingBox.southWest.coordinate.latitude,
						boundingBox.southWest.coordinate.longitude];

	NSString *typeParam = stringValueForPlacemarkType(type);
	if (typeParam.length > 0) {
		urlStr = [urlStr stringByAppendingFormat:@"&type=%@", typeParam];
	}

	[self parseGeocodingResponseForURLString:urlStr completionHandler:completionHandler];
}

- (void)geocodeAddressString:(NSString *)addressString
				 inProximity:(CLLocationCoordinate2D)coordinate
					withType:(CSPlacemarkType)type
					   limit:(NSInteger)limit
			customParameters:(nullable NSDictionary<NSString *, NSString *> *)parameters
		   completionHandler:(CSForwardGeocodeCompletionHandler)completionHandler {

	if (addressString.length == 0) {
		completionHandler(nil, [CSError errorWithDescription:@"Empty input"]);
		return;
	}

	int limitParam = MIN(MAX((int)limit, 1), 30);

	__block NSString *urlStr = [NSString stringWithFormat:@"%@geocode/%@/%@?limit=%i&proximity=%f,%f",
								[CSAuthenticationManager.sharedAuthenticationManager baseURL],
								self.mapIndex,
								addressString,
								limitParam,
								coordinate.latitude,
								coordinate.longitude];

	NSString *typeParam = stringValueForPlacemarkType(type);
	if (typeParam.length > 0) {
		urlStr = [urlStr stringByAppendingFormat:@"&type=%@", typeParam];
	}

	[parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
		urlStr = [urlStr stringByAppendingFormat:@"&%@=%@", key, obj];
	}];

	[self parseGeocodingResponseForURLString:urlStr completionHandler:completionHandler];
}

- (void)parseGeocodingResponseForURLString:(nonnull NSString *)urlStr
						 completionHandler:(CSForwardGeocodeCompletionHandler)completionHandler {

	__weak CSMapKit *weakSelf = self;
	[self responseFromURLString:urlStr completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		[weakSelf handleHTTPErrorsForResponse:response];

		if (error != nil) {
			completionHandler(nil, error);
			return;
		} else if (data != nil) {
			NSError *parsingError;

			NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
			if (parsingError != nil) {
				completionHandler(nil, parsingError);
				return;
			}

			CSForwardGeocodeResponse *forwardGeocodeResponse = [MTLJSONAdapter modelOfClass:CSForwardGeocodeResponse.class fromJSONDictionary:dict error:&parsingError];

			if (parsingError != nil) {
				completionHandler(nil, parsingError);
				return;
			} else if (forwardGeocodeResponse != nil) {
				if ([forwardGeocodeResponse.status isEqualToString:@"OK"]) {
					completionHandler(forwardGeocodeResponse.results, nil);
				} else {
					completionHandler(nil, [CSError errorWithDescription:forwardGeocodeResponse.status]);
				}
				return;
			}
		}
		completionHandler(nil, [CSError errorWithDescription:CEDARMAPS_UNKNOWN_ERROR]);
	}];
}

#pragma mark - Direction & Distance

- (void)calculateDirectionsFromSource:(CLLocation *)source
					   toDestinations:(NSArray<CLLocation *> *)destinations
				withCompletionHandler:(CSDirectionCompletionHandler)completionHandler {

	NSMutableArray *allPoints = [NSMutableArray arrayWithObject:source];
	[allPoints addObjectsFromArray:destinations];

	[self fetchDirectionOrDistanceForDistanceRoutePairs:nil
								  forDirectionLocations:allPoints
									   withInstructions:NO
												 locale:nil
								  withCompletionHandler:completionHandler];
}

- (void)calculateDirectionsWithInstructionsFromSource:(CLLocation *)source toDestinations:(NSArray<CLLocation *> *)destinations locale:(NSLocale *)locale withCompletionHandler:(CSDirectionCompletionHandler)completionHandler {

	NSMutableArray *allPoints = [NSMutableArray arrayWithObject:source];
	[allPoints addObjectsFromArray:destinations];

	[self fetchDirectionOrDistanceForDistanceRoutePairs:nil
								  forDirectionLocations:allPoints
									   withInstructions:YES
												 locale:locale
								  withCompletionHandler:completionHandler];

}

- (void)calculateDirections:(NSArray<CSRoutePair *> *)routePairs
	  withCompletionHandler:(CSDirectionCompletionHandler)completionHandler {

	[self fetchDirectionOrDistanceForDistanceRoutePairs:routePairs forDirectionLocations:nil withInstructions:NO locale:nil withCompletionHandler:completionHandler];
}

- (void)calculateDistance:(NSArray<CSRoutePair *> *)routePairs withCompletionHandler:(CSDirectionCompletionHandler)completionHandler {
	[self fetchDirectionOrDistanceForDistanceRoutePairs:routePairs forDirectionLocations:nil withInstructions:NO locale:nil withCompletionHandler:completionHandler];
}

- (void)fetchDirectionOrDistanceForDistanceRoutePairs:(nullable NSArray<CSRoutePair *> *)routePairs
								forDirectionLocations:(nullable NSArray<CLLocation *> *)locations
									 withInstructions:(BOOL)shouldGetInstructions
											   locale:(NSLocale *)locale
								withCompletionHandler:(CSDirectionCompletionHandler)completionHandler {

	NSString *pointsStr = @"";
	NSString *urlStr = @"";

	if (routePairs) {
		for (int i = 0; i < MIN(routePairs.count, 100); i++) {
			CSRoutePair *pair = routePairs[i];
			pointsStr = [pointsStr stringByAppendingFormat:@"%f,%f;%f,%f/",
						 pair.source.coordinate.latitude,
						 pair.source.coordinate.longitude,
						 pair.destination.coordinate.latitude,
						 pair.destination.coordinate.longitude];
		}
		if (pointsStr.length > 1) {
			pointsStr = [pointsStr substringToIndex:pointsStr.length - 1];
		}

		urlStr = [NSString stringWithFormat: @"%@distance/%@/",
				  [CSAuthenticationManager.sharedAuthenticationManager baseURL],
				  self.directionProfile
				  ];
	} else if (locations && locations.count > 1) {
		for (int i = 0; i < MIN(locations.count, 50); i++) {
			CLLocation *location = locations[i];
			pointsStr = [pointsStr stringByAppendingFormat:@"%f,%f;",
						 location.coordinate.latitude,
						 location.coordinate.longitude];
		}
		if (pointsStr.length > 1) {
			pointsStr = [pointsStr substringToIndex:pointsStr.length - 1];
		}

		urlStr = [NSString stringWithFormat: @"%@direction/%@/",
				  [CSAuthenticationManager.sharedAuthenticationManager baseURL],
				  self.directionProfile
				  ];
	} else {
		NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:400 userInfo:@{NSURLErrorFailingURLErrorKey: @"Bad request. Check Inputs."}];
		completionHandler(nil, error);
		return;
	}

	if (pointsStr.length > 0) {
		urlStr = [urlStr stringByAppendingString:pointsStr];
	}

	NSString *languageCode;
	if (@available(iOS 10, *)) {
		languageCode = locale.languageCode;
	} else {
		languageCode = [locale objectForKey:NSLocaleLanguageCode];
	}

	if (languageCode) {
		urlStr = [urlStr stringByAppendingFormat:@"?instructions=%@&locale=%@", shouldGetInstructions ? @"true" : @"false", languageCode];
	}

	__weak CSMapKit *weakSelf = self;
	[self responseFromURLString:urlStr completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

		[weakSelf handleHTTPErrorsForResponse:response];
		if (error != nil) {
			completionHandler(nil, error);
			return;
		} else if (data != nil) {
			NSError *parsingError;

			NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
			if (parsingError != nil) {
				completionHandler(nil, parsingError);
				return;
			}

			CSDirectionResponse *directionResponse = [MTLJSONAdapter modelOfClass:CSDirectionResponse.class fromJSONDictionary:dict error:&parsingError];

			if (parsingError != nil) {
				completionHandler(nil, parsingError);
				return;
			} else if (directionResponse != nil) {
				if ([directionResponse.status isEqualToString:@"OK"]) {
					completionHandler(directionResponse.routes, nil);
				} else {
					completionHandler(nil, [CSError errorWithDescription:directionResponse.status]);
				}
				return;
			}
		}
		completionHandler(nil, [CSError errorWithDescription:CEDARMAPS_UNKNOWN_ERROR]);
	}];
}

#pragma mark - Map Snapshot

- (void)createMapSnapshotWithOptions:(CSMapSnapshotOptions *)options withCompletionHandler:(CSMapSnapshotCompletionHandler)completionHandler {
	int validZoomLevel = MIN(17, MAX(6, (int)options.zoomLevel));

	NSString *positionParam = options.center != nil ? [NSString stringWithFormat:@"%f,%f,%i", options.center.coordinate.latitude, options.center.coordinate.longitude, validZoomLevel] : @"auto";

	CGFloat scale = [[UIScreen mainScreen] scale];

	CGSize validSize = CGSizeMake(MIN(MAX(options.size.width, 1), 1280), MIN(MAX(options.size.height, 1), 1280));
	NSString *sizeParam = [NSString stringWithFormat:@"%ix%i", (int)(validSize.width), (int)(validSize.height)];
	NSString *scaleParam = scale > 1.0 ? @"@2x": @"";

	NSString *markersParam = @"";
	if (options.markers != nil && options.markers.count > 0) {
		markersParam = @"?markers=";

		for (CSMapSnapshotMarker *marker in options.markers) {
			NSString *item = [NSString stringWithFormat:@"%@|%f,%f|",
							  marker.url == nil ? @"marker-default" : marker.url.absoluteString,
							  marker.coordinate.latitude,
							  marker.coordinate.longitude];
			markersParam = [markersParam stringByAppendingString:item];
		}
		markersParam = [markersParam substringToIndex:markersParam.length - 1];
	}

	NSString *urlStr = [NSString stringWithFormat:@"%@static/light/%@/%@%@%@",
						[CSAuthenticationManager.sharedAuthenticationManager baseURL],
						positionParam,
						sizeParam,
						scaleParam,
						markersParam];

	__weak CSMapKit *weakSelf = self;
	[self responseFromURLString:urlStr completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		[weakSelf handleHTTPErrorsForResponse:response];

		if (error != nil) {
			completionHandler(nil, error);
			return;
		} else if (data != nil) {
			dispatch_queue_t createImageQueue = dispatch_queue_create("Image Creation", NULL);
			dispatch_async(createImageQueue, ^{
				UIImage *image = [UIImage imageWithData:data];
				dispatch_async(dispatch_get_main_queue(), ^{
					CSMapSnapshot *mapSnapshot = [[CSMapSnapshot alloc] init];
					mapSnapshot.image = image;
					completionHandler(mapSnapshot, image == nil ? [CSError errorWithDescription:CEDARMAPS_RESPONSE_PARSING_ERROR] : nil);
				});
			});
			return;
		}
		completionHandler(nil, [CSError errorWithDescription:CEDARMAPS_UNKNOWN_ERROR]);
	}];
}

@end
