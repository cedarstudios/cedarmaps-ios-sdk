# CedarMap

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

To use CedarStudio Maps you need a pair of client ID and secret which is needed at the first step of initialising the SDK.

	CSAuthenticationManager *auth = [CSAuthenticationManager sharedManager];
	[auth setCredentialsWithClientID:@"<your client Id>" clientSecret:@"<your client secret>"];

If your project has its own base URL which is not the one SDK provides, you can set that here:

	auth.baseURL = @"http://api.myowncedarmaps.com/v1“;

Then an instance of CSMapKit should be initialised:

	CSMapKit *source = [[CSMapKit alloc] initWithMapID:@"cedarmaps.streets"];

``MapID`` is the style that will be shown by source and could be anything but at the moment the only accepted value is ``cedarmaps.streets``. We will add other values and style later.


There is an asynchronous method in CSMapKit which provides you with ``styleURL``:
	
	- (void)styleURLWithCompletion:(void (^) (NSURL *url))completion;

You then set the url as styleURL for ``MGLMapView``:
	
	self.mapView.styleURL = url;

or initialise a ``MGLMapView`` with the url:
	
	self.mapView = [[MGLMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 400) styleURL:url]; 

``CSMapKit`` has two methods for forward geocoding and reverse geocoding that return a ``NSArray`` and ``NSDictionary`` respectively as soon as their job gets done.

	- (void)forwardGeocodingWithQueryString:(NSString *)query parameters:(CSQueryParameters *)parameters completion:(void (^)(NSArray *results, NSError *error))completion;
	- (void)reverseGeocodingWithCoordinate:(CLLocationCoordinate2D)coordinate completion:(void (^)(NSDictionary *result, NSError *error))completion;

In case you have got a credential error with ``nil`` as the result, there might be something wrong with your credentials at server side. So, before retrying and sending the request again request a new access token by calling method ``- (void)requestAccessTokenFromServer:(void (^)(NSString *token, NSError *error))completion;`` of ``CSAuthenticationManager`` class.

Example projects for both ``Objective C`` and ``Swift`` are included.

## Requirements

- Mapbox-iOS-SDK 

## Installation

CedarMaps is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod 'CedarMaps'

## Author

CedarStudio ® 

## License

CedarMaps is available under the MIT license. See the LICENSE file for more info.

