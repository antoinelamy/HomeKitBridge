//
//  HKBSupportedAccessories.h
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-12-03.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKBDiscoveryService.h"

@interface HKBSupportedAccessories : NSObject

+ (NSArray *)supportedDiscoveryServices;

@end
