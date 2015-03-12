//
//  HKBSupportedAccessories.m
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-12-03.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import "HKBSupportedAccessories.h"

#import "HKBLIFXDiscoveryService.h"

@implementation HKBSupportedAccessories

+ (NSArray *)supportedDiscoveryServices
{
	static NSArray *_discoveryServices;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_discoveryServices = @[[HKBLIFXDiscoveryService class]];
	});
	return _discoveryServices;
}

@end
