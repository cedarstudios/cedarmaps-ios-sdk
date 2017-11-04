//
//  CSMapSnapshotOptions.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/29/17.
//

#import "CSMapSnapshotOptions.h"

@implementation CSMapSnapshotOptions

- (instancetype)init {
    self = [super init];
    if (self) {
        self.size = CGSizeMake(800, 600);
        self.zoomLevel = 14;
    }
    return self;
}

@end
