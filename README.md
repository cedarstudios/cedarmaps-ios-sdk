# CedarMap

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

To use CedarStudio Map you need a pair of client ID and secret which is needed at the first step of initialising the SDK.

	CSAuthenticationManager *auth = [CSAuthenticationManager sharedManager];
	[auth setCredentialsWithClientId:@“<your client Id>“ clientSecret:@“<your client secret>”];

If your project has its own base URL which is not the one SDK provides, you can set that here:

	auth.baseURL = @"http://api.myowncedarmaps.com/v1“;

Then an instance of CSMapSource should be initialised:

	CSMapSource *source = [[CSMapSource alloc] initWithMapId:@"cedarmaps.streets"];

``MapId`` actually is the style of will be shown by source and could be anything but at the moment the only accepted value is ``cedarmaps.streets``. We will add other values and style latter.


The map source instance will be used as tile source for a ``RMMapView``:
	
	self.mapView.tileSource = source;

or initialised a ``CSMapSource`` with your instance of ``RMMapView``:

	CSMapSource *source = [[CSMapSource alloc] initWithMapId:@"cedarmaps.streets" enablingDataOnMapView:self.mapView];

``CSMapSource`` has two methods for forward geocoding and reverse geocoding that returne a ``NSArray`` and ``NSDictionary`` respectively as soon as their job get done.

	- (void)forwardGeocodingWithQueryString:(NSString *)query parameters:(CSQueryParameters *)parameters completion:(void (^)(NSArray *results, NSError *error))completion;
	- (void)reverseGeocodingWithCoordinate:(CLLocationCoordinate2D)coordinate completion:(void (^)(NSDictionary *result, NSError *error))completion;

In case you have got a credential error with ``nil`` as the result, there might be something wrong with your credentials at server side. So, before retrying and sending the request again request a new access token by calling method ``- (void)requestAccessToken:(NSError *__autoreleasing *)error`` of ``CSAuthenticationManager`` class.

## Requirements

- Mapbox-iOS-SDK 

## Installation

CedarMap is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "CedarMap"

## Author

## License

CedarMap is available under the MIT license. See the LICENSE file for more info.

