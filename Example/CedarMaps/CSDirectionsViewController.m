//
//  CSDirectionsViewController.m
//  CedarMaps_Example
//
//  Created by Saeed Taheri on 10/30/17.
//  Copyright © 2017 Saeed Taheri. All rights reserved.
//

#import "CSDirectionsViewController.h"
@import CedarMaps;

@interface CSDirectionsViewController () <MGLMapViewDelegate>

@property (weak, nonatomic) IBOutlet CSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIStackView *distanceStackView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIView *hintView;
@property (strong, nonatomic) NSMutableArray<MGLPointAnnotation *> *markers;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSMeasurementFormatter *distanceFormatter;

@end

@implementation CSDirectionsViewController

- (void)setResetButton:(UIButton *)resetButton {
    resetButton.layer.cornerRadius = 10.0;
    resetButton.layer.masksToBounds = YES;
    [resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetButton setBackgroundColor:self.tabBarController.tabBar.tintColor];
    resetButton.hidden = YES;
    _resetButton = resetButton;
}

- (void)setDistanceStackView:(UIStackView *)distanceStackView {
    distanceStackView.hidden = YES;
    _distanceStackView = distanceStackView;
}

- (void)setSpinner:(UIActivityIndicatorView *)spinner {
    spinner.hidden = YES;
    _spinner = spinner;
}

- (NSMutableArray<MGLPointAnnotation *> *)markers {
    if (!_markers) {
        _markers = [NSMutableArray arrayWithCapacity:2];
    }
    return _markers;
}

- (NSMeasurementFormatter *)distanceFormatter {
    if (!_distanceFormatter) {
        _distanceFormatter = [[NSMeasurementFormatter alloc] init];
        _distanceFormatter.unitStyle = NSFormattingUnitStyleShort;
        _distanceFormatter.unitOptions = NSMeasurementFormatterUnitOptionsNaturalScale;
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.alwaysShowsDecimalSeparator = NO;
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.maximumFractionDigits = 2;
        _distanceFormatter.numberFormatter = numberFormatter;
    }
    return _distanceFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView.delegate = self;
    [self setupSingleTapGestureOnMapView];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:NULL completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (self.mapView.annotations) {
            [self.mapView showAnnotations:self.mapView.annotations animated:YES];
        }
    }];
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
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[sender locationInView:sender.view] toCoordinateFromView:sender.view];
    
    if (self.markers.count == 0) {
        [self addMarkerAtCoordinate:coordinate];
    } else if (self.markers.count == 1) {
        [self addMarkerAtCoordinate:coordinate];
        
        CLLocation *location0 = [[CLLocation alloc] initWithLatitude:self.markers[0].coordinate.latitude longitude:self.markers[0].coordinate.longitude];
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:self.markers[1].coordinate.latitude longitude:self.markers[1].coordinate.longitude];

        [self computeDirectionsFromSource:location0 toDestination:location1];
    }
}

- (IBAction)resetMap:(UIButton *)sender {
    [self resetToInitialState];
}

- (void)resetToInitialState {
    self.resetButton.hidden = YES;
    self.distanceStackView.hidden = YES;
    self.hintView.hidden = NO;
    self.spinner.hidden = YES;
    
    [self.markers removeAllObjects];
    if (self.mapView.annotations) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
}

- (void)computeDirectionsFromSource:(CLLocation *)source toDestination:(CLLocation *)destination {
    
    self.hintView.hidden = YES;
    [self.spinner startAnimating];
    self.spinner.hidden = NO;
    
    __weak CSDirectionsViewController *weakSelf = self;
    [[CSMapKit sharedMapKit] calculateDirections:@[[[CSRoutePair alloc] initWithSource:source destination:destination]] withCompletionHandler:^(NSArray<CSRoute *> * _Nullable routes, NSError * _Nullable error) {

        [weakSelf.spinner stopAnimating];
        [weakSelf.spinner setHidden:YES];
        
        CSRoute *route = routes.firstObject;
        if (route) {
            NSMeasurement *distance = [[NSMeasurement alloc] initWithDoubleValue:route.distance unit:[NSUnitLength meters]];
            weakSelf.distanceLabel.text = [weakSelf.distanceFormatter stringFromMeasurement:distance];
            
            
            weakSelf.distanceStackView.hidden = NO;
            weakSelf.resetButton.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                if (route.points) {
                    [weakSelf drawLocations:route.points];
                }
            }];

        } else if (error) {
            [weakSelf resetToInitialState];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"Directions Error", "") message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", "") style:UIAlertActionStyleCancel handler:NULL]];
            [weakSelf presentViewController:alert animated:YES completion:NULL];
        }
    }];
}

- (void)drawLocations:(NSArray<CLLocation *> *)locations {
    CLLocationCoordinate2D coordinates[locations.count];
    for (int i = 0; i < locations.count; i++) {
        coordinates[i] = locations[i].coordinate;
    }
    
    MGLPolyline *polyline = [[MGLPolyline alloc] init];
    [polyline setCoordinates:coordinates count:locations.count];
    
    [self.mapView addAnnotation:polyline];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

- (void)addMarkerAtCoordinate:(CLLocationCoordinate2D)coordinate {
    MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [self.markers addObject:annotation];
    [self.mapView addAnnotation:annotation];
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation {
    if (annotation == self.markers.firstObject) {
        UIImage *image = [UIImage imageNamed:@"marker_icon_start"];
        image = [image imageWithAlignmentRectInsets:
                 UIEdgeInsetsMake(0, 0, image.size.height / 2, 0)];

        return [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"marker_start_identifier"];
    } else if (annotation == self.markers.lastObject) {
        UIImage *image = [UIImage imageNamed:@"marker_icon_end"];
        image = [image imageWithAlignmentRectInsets:
                 UIEdgeInsetsMake(0, 0, image.size.height / 2, 0)];

        return [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"marker_end_identifier"];
    }
    return nil;
}

- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation {
    return 0.9;
}

- (CGFloat)mapView:(MGLMapView *)mapView lineWidthForPolylineAnnotation:(MGLPolyline *)annotation {
    return 6.0;
}

@end
