//
//  CSSearchViewController.m
//  CedarMap
//
//  Created by Emad A. on 6/02/2015.
//  Copyright (c) 2015 Emad A. All rights reserved.
//

#import "CSSearchViewController.h"

#pragma mark - CSSearchViewController Private Interface 
#pragma mark

@interface CSSearchViewController () <RMMapViewDelegate>

@property (nonatomic, strong) CSMapSource *mapSource;

@end

#pragma mark - CSSearchViewController Implementation
#pragma mark

@implementation CSSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Customizing search view and textfield
    self.searchView.layer.shadowOffset = CGSizeMake(0, 1);
    self.searchView.layer.shadowOpacity = .3;
    self.searchView.layer.shadowRadius = 1.5;
    self.searchView.layer.cornerRadius = 2;
    self.searchView.alpha = .95;

    // Initializing map source
    self.mapSource = [[CSMapSource alloc] initWithMapId:@"cedarmaps.streets"];

    // Setting map view properties
    self.mapView.tileSource = self.mapSource;
    self.mapView.hideAttribution = YES;
    self.mapView.showLogoBug = NO;
    self.mapView.zoom = 16;

    //[self.mapView removeAllCachedImages];

    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(35.757552763570196, 51.41000747680664);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.mapView.annotations.count == 0) {
        [self.searchTextField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.spinner startAnimating];
    [textField resignFirstResponder];

    [self searchWithQueryString:textField.text];

    return NO;
}

#pragma mark - RMMapViewDelegate Methods

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation) {
        return nil;
    }

    RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"star"]];
    marker.anchorPoint = CGPointMake(1, 1);
    marker.canShowCallout = YES;

    return marker;
}

#pragma mark - Private Methods

- (void)searchWithQueryString:(NSString *)query
{
    CSQueryParameters *params = [CSQueryParameters new];
    [params addLocationWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    [self.mapSource forwardGeocodingWithQueryString:query parameters:params completion:^(NSArray *results, NSError *error) {
        [self.spinner stopAnimating];
        
        if (error != nil) {
            [[[UIAlertView alloc] initWithTitle:@"بروز خطا"
                                        message:error.localizedDescription
                                       delegate:nil
                              cancelButtonTitle:@"باشه"
                              otherButtonTitles:nil] show];
            return;
        }

        [self.mapView removeAllAnnotations];

        for (NSDictionary *item in results) {
            NSArray *center = [[item objectForKey:@"location"][@"center"] componentsSeparatedByString:@","];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([center[0] doubleValue], [center[1] doubleValue]);
            RMAnnotation *annotation = [RMAnnotation annotationWithMapView:self.mapView
                                                                coordinate:coordinate
                                                                  andTitle:[item objectForKey:@"name"]];
            annotation.userInfo = @"search_result";
            [self.mapView addAnnotation:annotation];
        }

        if (results.count > 0) {
            RMAnnotation *firstAnnotation = [self.mapView.annotations objectAtIndex:0];
            [self.mapView setCenterCoordinate:firstAnnotation.coordinate animated:YES];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"جستجو بدون نتیجه"
                                       message:@"مکان مورد نظر پیدا نشد."
                                      delegate:nil
                             cancelButtonTitle:@"باشه"
                              otherButtonTitles:nil] show];
        }
    }];
}

@end
