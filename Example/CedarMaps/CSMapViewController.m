//
//  CSViewController.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/21/2017.
//  Copyright (c) 2017 Saeed Taheri. All rights reserved.
//

#import "CSMapViewController.h"
@import CedarMaps;

@interface CSMapViewController ()<MGLMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet CSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation CSMapViewController

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.mapView setShowsUserLocation:YES];
    }
    
    [self setupCurrentLocationButtonVisuals];
    [self setupSingleTapGestureOnMapView];
    [self addMarkerAtCoordinate:self.mapView.centerCoordinate];
}

- (IBAction)showCurrentLocation:(id)sender {
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if (self.mapView.userLocation.location && CLLocationCoordinate2DIsValid(self.mapView.userLocation.location.coordinate)) {
                [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
            }
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
        default:
            break;
    }
}

- (void)setupSingleTapGestureOnMapView {
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tgr.numberOfTapsRequired = 1;
    tgr.numberOfTouchesRequired = 1;
    
    //This loop goes through the gesture recognizers of default mapview to avoid conflicts with the added one.
    for (UIGestureRecognizer *recognizer in self.mapView.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [tgr requireGestureRecognizerToFail:recognizer];
        }
    }
    [self.mapView addGestureRecognizer:tgr];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    if (self.mapView.annotations) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[sender locationInView:sender.view] toCoordinateFromView:sender.view];
    [self addMarkerAtCoordinate:coordinate];
}

- (void)addMarkerAtCoordinate:(CLLocationCoordinate2D)coordinate {
    MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [self.mapView addAnnotation:annotation];
}

- (void)setupCurrentLocationButtonVisuals {
    CALayer *layer = self.currentLocationButton.layer;
    layer.cornerRadius = 12.0;
    layer.masksToBounds = NO;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 12.0f;
    layer.shadowOpacity = 0.1f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:layer.bounds cornerRadius:layer.cornerRadius] CGPath];
    layer.backgroundColor = [UIColor whiteColor].CGColor;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.mapView setShowsUserLocation:YES];
            break;
        default:
            break;
    }
}

@end
