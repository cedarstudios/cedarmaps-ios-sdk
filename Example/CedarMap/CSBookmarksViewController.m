//
//  CSBookmarksViewController.m
//  CedarMap
//
//  Created by Emad A. on 01/19/2015.
//  Copyright (c) 2014 Emad A.. All rights reserved.
//

#import "CSBookmarksViewController.h"

#pragma mark - CSViewController Private Interface
#pragma maek

@interface CSBookmarksViewController () <RMMapViewDelegate>

@end

#pragma mark - CSViewController Implementation
#pragma maek

@implementation CSBookmarksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CSAuthenticationManager *auth = [CSAuthenticationManager sharedManager];
    [auth setCredentialsWithClientId:@"user"
                        clientSecret:@"pass"];

    CSMapSource *source = [[CSMapSource alloc] initWithMapId:@"cedarmaps.streets"];

    self.mapView.tileSource = source;
    self.mapView.hideAttribution = YES;
    self.mapView.showLogoBug = NO;
    self.mapView.zoom = 16;

    [self.mapView removeAllCachedImages];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    /*
    [self markBusStation];
    [self markTrainStation];
    [self markPointNumberOne];
    [self markPointNumberTwo];
    [self markPointNumberThree];
     */
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(35.770889877650724, 51.439468860626214);
}

#pragma mark - 

#pragma mark - RMMapViewDelegate Methods

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation) {
        return nil;
    }

    RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:annotation.userInfo]];
    marker.anchorPoint = CGPointMake(1, 1);
    marker.canShowCallout = YES;

    return marker;
}

#pragma mark -

- (void)markBusStation
{
    RMAnnotation *annotation = [RMAnnotation annotationWithMapView:self.mapView
                                                        coordinate:CLLocationCoordinate2DMake(35.770889877650724, 51.439468860626214)
                                                          andTitle:@"ایستگاه اتوبوس"];
    annotation.userInfo = @"bus_station";
    [self.mapView addAnnotation:annotation];
}

- (void)markTrainStation
{
    RMAnnotation *annotation = [RMAnnotation annotationWithMapView:self.mapView
                                                        coordinate:CLLocationCoordinate2DMake(35.772857173873305, 51.437859535217285)
                                                          andTitle:@"مترو"];
    annotation.userInfo = @"train_station";
    [self.mapView addAnnotation:annotation];
}

- (void)markPointNumberOne
{
    RMAnnotation *annotation = [RMAnnotation annotationWithMapView:self.mapView
                                                        coordinate:CLLocationCoordinate2DMake(35.77633899479261, 51.4344048500061)
                                                          andTitle:@"نقطه اول"];
    annotation.userInfo = @"point_one";
    [self.mapView addAnnotation:annotation];
}

- (void)markPointNumberTwo
{
    RMAnnotation *annotation = [RMAnnotation annotationWithMapView:self.mapView
                                                        coordinate:CLLocationCoordinate2DMake(35.77943768718256, 51.437666416168206)
                                                          andTitle:@"نقطه دوم"];
    annotation.userInfo = @"point_two";
    [self.mapView addAnnotation:annotation];
}

- (void)markPointNumberThree
{
    RMAnnotation *annotation = [RMAnnotation annotationWithMapView:self.mapView
                                                        coordinate:CLLocationCoordinate2DMake(35.77773168047123, 51.44279479980469)
                                                          andTitle:@"نقطه سوم"];
    annotation.userInfo = @"point_three";
    [self.mapView addAnnotation:annotation];
}

@end
