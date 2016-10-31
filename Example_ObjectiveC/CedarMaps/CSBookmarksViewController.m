//
//  CSBookmarksViewController.m
//  CedarMap
//
//  Created by Emad A. on 01/19/2015.
//  Copyright (c) 2014 Emad A.. All rights reserved.
//

#import "CSBookmarksViewController.h"

#pragma mark - CSViewController Private Interface

@interface CSBookmarksViewController () <MGLMapViewDelegate>

@property (nonatomic, strong) CSMapKit *mapKit;

@end

#pragma mark - CSViewController Implementation
#pragma maek

@implementation CSBookmarksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CSAuthenticationManager *auth = [CSAuthenticationManager sharedManager];
    [auth setCredentialsWithClientID:nil
                        clientSecret:nil];

    self.mapKit = [[CSMapKit alloc] initWithMapID:@"cedarmaps.streets"];
    
    [self.mapKit styleURLWithCompletion:^(NSURL *url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mapView.styleURL = url;
        });
    }];
    
    self.mapView.attributionButton.alpha = 0;
    self.mapView.logoView.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    [self markBusStation];
//    [self markTrainStation];
//    [self markPointNumberOne];
//    [self markPointNumberTwo];
//    [self markPointNumberThree];
    
    [self.mapKit reverseGeocodingWithCoordinate:CLLocationCoordinate2DMake(35.770889877650724, 51.439468860626214) completion:^(NSDictionary *result, NSError *error) {
        
        NSString *city = result[@"city"];
        NSString *locality = result[@"locality"];
        NSString *address = result[@"address"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
            point.coordinate = CLLocationCoordinate2DMake(35.770889877650724, 51.439468860626214);
            point.title = [NSString stringWithFormat:@"%@، %@، %@", city, locality, address];
            point.subtitle = nil;
            
            [self.mapView addAnnotation:point];
        });
    }];
}

#pragma mark

- (IBAction)attributionDidTouchUpInside:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://cedarmaps.com"]];
}

#pragma mark - MGLMapViewDelegate Methods

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation {
    if (!annotation.subtitle) {
        return nil;
    }
    MGLAnnotationImage *image = [MGLAnnotationImage annotationImageWithImage:[UIImage imageNamed:annotation.subtitle] reuseIdentifier:annotation.subtitle];
    return image;
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return YES;
}


#pragma mark -

- (void)markBusStation
{
    MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(35.770889877650724, 51.439468860626214);
    annotation.title = @"ایستگاه اتوبوس";
    annotation.subtitle = @"bus_station";
    [self.mapView addAnnotation:annotation];
}

- (void)markTrainStation
{
    MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(35.772857173873305, 51.437859535217285);
    annotation.title = @"مترو";
    annotation.subtitle = @"train_station";
    [self.mapView addAnnotation:annotation];
}

- (void)markPointNumberOne
{
    MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(35.77633899479261, 51.4344048500061);
    annotation.title = @"نقطه اول";
    annotation.subtitle = @"point_one";
    [self.mapView addAnnotation:annotation];
}

- (void)markPointNumberTwo
{
    MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(35.77943768718256, 51.437666416168206);
    annotation.title = @"نقطه دوم";
    annotation.subtitle = @"point_two";
    [self.mapView addAnnotation:annotation];
}

- (void)markPointNumberThree
{
    MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(35.77773168047123, 51.44279479980469);
    annotation.title = @"نقطه سوم";
    annotation.subtitle = @"point_three";
    [self.mapView addAnnotation:annotation];
}

@end
