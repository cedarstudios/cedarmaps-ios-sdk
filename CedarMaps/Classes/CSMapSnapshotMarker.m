//
//  CSMapSnapshotMarker.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/29/17.
//

#import "CSMapSnapshotMarker.h"

@interface CSMapSnapshotMarker()

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong, nullable) NSURL *url;

@end

@implementation CSMapSnapshotMarker

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.url = nil;
    }
    return self;
}

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate markerURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.url = url;
    }
    return self;
}

@end
