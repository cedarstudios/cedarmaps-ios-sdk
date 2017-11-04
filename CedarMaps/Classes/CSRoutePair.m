//
//  CSRoutePair.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/25/17.
//

#import "CSRoutePair.h"

@implementation CSRoutePair

- (instancetype)initWithSource:(CLLocation *)source destination:(CLLocation *)destination {
    self = [super init];
    if (self) {
        self.source = source;
        self.destination = destination;
    }
    return self;
}

@end
