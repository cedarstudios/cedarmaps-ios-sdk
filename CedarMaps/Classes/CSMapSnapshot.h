//
//  CSMapSnapshot.h
//  CedarMaps
//
//  Created by Saeed Taheri on 10/29/17.
//

#import <UIKit/UIKit.h>
@import CoreLocation;


/**
 The result which is returned in the completion handler for a CSMapSnapshot request
 */
@interface CSMapSnapshot : NSObject


/**
 The image result of a map snapshot.
 */
@property (nonatomic, strong, nullable) UIImage *image;

@end

typedef void (^CSMapSnapshotCompletionHandler)(CSMapSnapshot * _Nullable snapshot, NSError * _Nullable error);
