# CedarMaps iOS SDK

This guide will take you through the process of integrating CedarMaps into your iOS application.

All the mentioned methods and tools in this document are tested on Xcode v9.3.

## Table of Contents
- [Installation](#installation)
	-	[Required Permissions](#required-permissions)
	-	[Configuring CedarMaps](#configuring-cedarmaps)
		- [Changing API Base URL](#changing-api-base-url)
    -   [Mapbox](#mapbox)
        - [CSMapView](#csmapview)
- [API Methods](#api-methods)
	-	[Forward Geocoding](#forward-geocoding)
	-	[Reverse Geocoding](#reverse-geocoding)
	-	[Direction](#direction)
	-	[Distance](#distance)
	-	[Static Map Image](#static-map-images)
- [Sample App](#more-examples-via-the-sample-app)


## Installation

CedarMaps is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile and run `pod install`.

```ruby
pod 'CedarMaps'
```

### Required Permissions

If your app needs to access location services, add a description usage for `NSLocationWhenInUseUsageDescription` in your app's `Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>THE REASON OF REQUESTING LOCATION</string>
```

### Configuring CedarMaps

To use CedarMaps tiles and methods, you need a pair of `clientID` and `clientSecret` which is used at the first step of initialising the SDK.

`AppDelegate`'s `applicationDidFinishLaunchingWithOptions:` is a good place to initialize CedarMaps.

```objc
[[CSMapKit sharedMapKit] setCredentialsWithClientID:@"CLIENT_ID" clientSecret:@"CLIENT_SECRET"];
```
```swift
CSMapKit.shared.setCredentialsWithClientID("CLIENT_ID", clientSecret: "CLIENT_SECRET")
```

#### Changing API Base URL

If you've received an API Base URL, you can set it on `CSMapKit` shared object:

```objc
[[CSMapKit sharedMapKit] setAPIBaseURL:@"API_BASE_URL"];
```
```swift
CSMapKit.shared.setAPIBaseURL("API_BASE_URL")
```

### Mapbox

CedarMaps SDK is based on [Mapbox iOS SDK v4.0](https://github.com/mapbox/mapbox-gl-native) and provides extra API methods over Mapbox. 
For more information about how to use Mapbox components and methods such as **Adding Markers**, **Showing Current Location**, etc., please see [Mapbox Getting Started](https://www.mapbox.com/help/first-steps-ios-sdk/).

#### CSMapView

If you want to use CedarMaps tiles, there's one extra step to do. After doing the following snippet, you can use an instance of ```CSMapView```, which is a subclass of Mapbox ```MGLMapView```, in either Storyboard or code; they shall not be used interchangeably.

```objc
[[CSMapKit sharedMapKit] prepareMapTiles:^(BOOL isReady, NSError * _Nullable error) {
    
}];
```
```swift
CSMapKit.shared.prepareMapTiles { isSuccesful, error in
                
}
```

## API Methods

In addition to using MapView, you can use CedarMaps API to retrieve location based data and street search.

All API calls are asynchronous; they don't block the Main Queue. The completion handlers are all called on the Main Queue.

You can also consult [CSMapKit.h](http://gitlab.cedar.ir/cedar.studios/cedarmaps-sdk-ios-public/blob/master/CedarMaps/Classes/CSMapKit.h) for detailed info on all of our methods. Some of the main methods are mentioned below.

### Forward Geocoding

For finding a street or some limited POIs, you can easily call ```geocode``` methods.

```objc
- (void)geocodeAddressString:(nonnull NSString *)addressString
               inBoundingBox:(nonnull CSBoundingBox *)boundingBox
                    withType:(CSPlacemarkType)type
                       limit:(NSInteger)limit
           completionHandler:(nonnull CSForwardGeocodeCompletionHandler)completionHandler;
```
```swift
open func geocodeAddressString(_ addressString: String, in boundingBox: CSBoundingBox, with type: CSPlacemarkType, limit: Int, completionHandler: @escaping CSForwardGeocodeCompletionHandler)
```

More advanced street searches are available in the sample app.

### Reverse Geocoding

You can retrieve data about a location by using Reverse Geocode API.

```objc
- (void)reverseGeocodeLocation:(nonnull CLLocation *)location
             completionHandler:(nonnull CSReverseGeocodeCompletionHandler)completionHandler;

```
```swift
open func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CSReverseGeocodeCompletionHandler)
```

### Direction
     
This method calculates the direction between points. It can be called with up to 50 different pairs in a single request.

```objc
- (void)calculateDirections:(nonnull NSArray<CSRoutePair *> *)routePairs withCompletionHandler:(nonnull CSDirectionCompletionHandler)completionHandler;
```
```swift
open func calculateDirections(_ routePairs: [CSRoutePair], withCompletionHandler completionHandler: @escaping CSDirectionCompletionHandler)
```

### Distance

This method calculates the distance between points in meters. It can be called with up to 15 different points in a single request.

```objc
- (void)calculateDistance:(nonnull NSArray<CSRoutePair *> *)routePairs withCompletionHandler:(nonnull CSDirectionCompletionHandler)completionHandler;
```
```swift
open func calculateDistance(_ routePairs: [CSRoutePair], withCompletionHandler completionHandler: @escaping CSDirectionCompletionHandler)
```

### Static Map Images
You can request an ```UIImage``` of a desired map view with the following code snippet. You should create a ```CSMapSnapshotOptions``` beforehand to set custom properties.

```objc
CSMapSnapshotOptions *options = [[CSMapSnapshotOptions alloc] init];
options.center = [[CLLocation alloc] initWithLatitude:LATITUDE longitude:LONGITUDE];
options.zoomLevel = ZOOM_LEVEL;
options.size = CGSizeMake(WIDTH, HEIGHT);

[CSMapKit.sharedMapKit createMapSnapshotWithOptions:options withCompletionHandler:^(CSMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
    
}];
```
```swift
let options = CSMapSnapshotOptions()
options.center = CLLocation(latitude: LATITUDE, longitude: LONGITUDE)
options.zoomLevel = ZOOM_LEVEL
options.size = CGSize(width: WIDTH, height: HEIGHT)

CSMapKit.shared.createMapSnapshot(with: options) { (snapshot, error) in

}
```
Optionally, you can specify markeres to be drawn on the map by setting ```markers``` property on ```CSMapSnapshotOptions``` instance.

## More Examples via the Sample App

To run the example project, clone the repo, and run `pod install` from the **Example** directory first.
Then, in ```CSAppDelegate.m``` file, set your own `clientID` and `clientSecret`.

The example project is a mix of Swift and Objective-C.  
