//
//  CSViewController.m
//  CedarMap
//
//  Created by Emad A. on 01/19/2015.
//  Copyright (c) 2014 Emad A.. All rights reserved.
//

#import "CSViewController.h"
#import "CedarMap.h"

#pragma mark - CSViewController Private Interface
#pragma maek

@interface CSViewController ()

@property (nonatomic, strong) RMMapView *mapView;

@end

#pragma mark - CSViewController Implementation
#pragma maek

@implementation CSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CSMapSource *source = [[CSMapSource alloc] init];

    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.tileSource = source;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(35.757552763570196, 51.41000747680664);

    //[self.mapView removeAllCachedImages];
    [self.view addSubview:self.mapView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Street Search Example
    /*
    CSMapSource *source = (CSMapSource *)self.mapView.tileSource;
    CSQueryParameters *params = [CSQueryParameters new];
    [params addCity:@"Sydney"];
    [params addDistance:5000];
    [params addLimit:9];
    [params addLocationWithLatitude:123 longitude:45.678];
    [source searchStreetWithQueryString:@"همت" parameters:params completion:^(NSDictionary *result, NSError *error) {
        NSLog(@"result: %@",result);
        NSLog(@"error: %@",error);
    }];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
