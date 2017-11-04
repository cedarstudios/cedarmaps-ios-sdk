# CedarMaps

[![Version](https://img.shields.io/cocoapods/v/CedarMaps.svg?style=flat)](http://cocoapods.org/pods/CedarMaps)
[![License](https://img.shields.io/cocoapods/l/CedarMaps.svg?style=flat)](http://cocoapods.org/pods/CedarMaps)
[![Platform](https://img.shields.io/cocoapods/p/CedarMaps.svg?style=flat)](http://cocoapods.org/pods/CedarMaps)

## Usage

### Initialization
To use CedarMaps tiles and methods, you need a pair of Client ID and Client Secret which is used at the first step of initialising the SDK.

```objc
[[CSMapKit sharedMapKit] setCredentialsWithClientID:@"CLIENT_ID" clientSecret:@"CLIENT_SECRET"];
```
```swift
CSMapKit.shared.setCredentialsWithClientID("CLIENT_ID", clientSecret: "CLIENT_SECRET")
```

If your project has its own base URL which is not the one SDK provides, you can set it via this method:

```objc
[[CSMapKit sharedMapKit] setAPIBaseURL:@"API_BASE_URL"];
```
```swift
CSMapKit.shared.setAPIBaseURL("API_BASE_URL")
```

If you want to use CedarMaps tiles, there's one extra step to do. After doing this you can use an instance of ```CSMapView``` which is a subclass of Mapbox ```MGLMapView``` to show CedarMaps tiles.

```objc
[[CSMapKit sharedMapKit] prepareMapTiles:^(BOOL isReady, NSError * _Nullable error) {
    
}];
```
```swift
CSMapKit.shared.prepareMapTiles { isSuccesful, error in
                
}
```

### Geocoding Methods

There are a couple of methods related to reverse and forward geocoding points and addresses. These methods are all asynchronous and their completion handlers are called on the main queue.

Some of these methods are as follows. Check ```CSMapKit``` header fore more information.

```objc
- (void)reverseGeocodeLocation:(nonnull CLLocation *)location
             completionHandler:(nonnull CSReverseGeocodeCompletionHandler)completionHandler;

- (void)geocodeAddressString:(nonnull NSString *)addressString
                    inRegion:(nonnull CLCircularRegion *)region
           completionHandler:(nonnull CSForwardGeocodeCompletionHandler)completionHandler;

- (void)geocodeAddressString:(nonnull NSString *)addressString
               inBoundingBox:(nonnull CSBoundingBox *)boundingBox
                    withType:(CSPlacemarkType)type
                       limit:(NSInteger)limit
           completionHandler:(nonnull CSForwardGeocodeCompletionHandler)completionHandler;
```
```swift
open func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CSReverseGeocodeCompletionHandler)

open func geocodeAddressString(_ addressString: String, in region: CLCircularRegion, completionHandler: @escaping CSForwardGeocodeCompletionHandler)

open func geocodeAddressString(_ addressString: String, in boundingBox: CSBoundingBox, with type: CSPlacemarkType, limit: Int, completionHandler: @escaping CSForwardGeocodeCompletionHandler)
```

### Distance and Directions
``CSMapKit`` has two methods for getting distance and directions between one pair or up to 100 pairs of points. They are mostly the same.

This is the directions method for both Objective-C and Swift.
```objc
- (void)calculateDirections:(nonnull NSArray<CSRoutePair *> *)routePairs withCompletionHandler:(nonnull CSDirectionCompletionHandler)completionHandler;
```
```swift
open func calculateDirections(_ routePairs: [CSRoutePair], withCompletionHandler completionHandler: @escaping CSDirectionCompletionHandler)
```

### Map Snapshot (Static Map Image)
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

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
Then, in ```CSAppDelegate.m``` file, set your own Client ID and Client Secret.

The example project is a mix of Swift and Objective-C.  

Since CedarMaps is using ```Mapbox``` for rendering map tiles, you can consult their [documentation](https://www.mapbox.com/ios-sdk/)

## Requirements

- Mapbox-iOS-SDK 

## Installation

CedarMaps is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CedarMaps'
```

## Author

CedarStudio ®, info@cedarmaps.com

## License

CedarMaps is available under the MIT license. See the LICENSE file for more info.
