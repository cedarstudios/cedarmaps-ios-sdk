//
//  CSSearchViewController.h
//  CedarMap
//
//  Created by Emad A. on 6/02/2015.
//  Copyright (c) 2015 Emad A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CedarMap.h"

@interface CSSearchViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet RMMapView *mapView;
@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UIView *searchTextField;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;

@end
