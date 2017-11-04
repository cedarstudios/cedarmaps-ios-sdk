//
//  CSError.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/24/17.
//

#import "CSError.h"

@implementation CSError

+ (NSError *)errorWithDescription:(NSString *)errorDescription {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorDescription};
    return [NSError errorWithDomain:@"NSCedarMapsDomain" code:-69 userInfo:userInfo];
}

@end
