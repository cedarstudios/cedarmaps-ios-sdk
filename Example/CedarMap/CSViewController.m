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

@property (nonatomic, strong) CSMapSample *mapView;

@end

#pragma mark - CSViewController Implementation
#pragma maek

@implementation CSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.mapView = [[CSMapSample alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.mapView setZoom:16 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
