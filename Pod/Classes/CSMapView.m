//
//  CSMapSample.m
//  Pods
//
//  Created by Emad A. on 19/01/2015.
//
//

#import "CSMapView.h"

@implementation CSMapView

- (id)init {
    self = [super init];
    if (self != nil) {
        [self prepareForUse];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self prepareForUse];
    }
    return self;
}

- (void)setShowLogoBug:(BOOL)showLogoBug {
    [super setShowLogoBug:NO];
}

- (void)setHideAttribution:(BOOL)hideAttribution {
    [super setHideAttribution:YES];
}

#pragma mark

- (void)prepareForUse {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"csmap" ofType:@"json"];
    NSURL *sourceRefURL = [NSURL fileURLWithPath:bundlePath];
    RMMapboxSource *source = [[RMMapboxSource alloc] initWithReferenceURL:sourceRefURL];

    self.tileSource = source;
    self.centerCoordinate = CLLocationCoordinate2DMake(35.757552763570196,  51.41000747680664);

    [super setHideAttribution:YES];
    [super setShowLogoBug:NO];
}

@end
