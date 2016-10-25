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

@interface CSSearchViewController () <MGLMapViewDelegate>

@property (nonatomic, strong) CSMapKit *mapKit;

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

    if (self.mapView.annotations.count == 0) {
        [self.searchTextField becomeFirstResponder];
    }
}

#pragma mark

- (IBAction)attributionDidTouchUpInside:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://cedarmaps.com"]];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.spinner startAnimating];
    [textField resignFirstResponder];

    [self searchWithQueryString:textField.text];

    return NO;
}

#pragma mark - MGLMapViewDelegate Methods

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation {
    
    MGLAnnotationImage *image = [MGLAnnotationImage annotationImageWithImage:[UIImage imageNamed:@"star"] reuseIdentifier:@"marker"];
    return image;
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return YES;
}

#pragma mark - Private Methods

- (void)searchWithQueryString:(NSString *)query
{
    CSQueryParameters *params = [[CSQueryParameters alloc] init];
    [params addLocationWithCoordinate:self.mapView.centerCoordinate];
    [params addDistance:1.0];
    
    [self.mapKit forwardGeocodingWithQueryString:query parameters:params completion:^(NSArray *results, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            
            if (error != nil) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"بروز خطا" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"باشه" style:UIAlertActionStyleCancel handler:NULL]];
                
                [self presentViewController:alert animated:YES completion:NULL];
                
                return;
            }
            
            if (self.mapView.annotations && self.mapView.annotations.count > 0) {
                [self.mapView removeAnnotations:self.mapView.annotations];
            }
            
            for (NSDictionary *item in results) {
                NSArray *center = [[item objectForKey:@"location"][@"center"] componentsSeparatedByString:@","];
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([center[0] doubleValue], [center[1] doubleValue]);
                
                MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
                annotation.coordinate = coordinate;
                annotation.title = [item objectForKey:@"name"];
                
                [self.mapView addAnnotation:annotation];
            }
            
            if (results.count > 0) {
                MGLPointAnnotation *firstAnnotation = self.mapView.annotations.firstObject;
                [self.mapView setCenterCoordinate:firstAnnotation.coordinate animated:YES];
            }
            else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"جستجو بدون نتیجه" message:@"مکان مورد نظر پیدا نشد." preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"باشه" style:UIAlertActionStyleCancel handler:NULL]];
                
                [self presentViewController:alert animated:YES completion:NULL];
            }
        });
    }];
}

@end
