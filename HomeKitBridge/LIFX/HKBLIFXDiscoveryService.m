//
//  HKBLIFXDiscoveryService.m
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-12-03.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import "HKBLIFXDiscoveryService.h"
#import "HKBLIFXLightAccessory.h"

#import <LIFXKit/LIFXKit.h>

@interface HKBLIFXDiscoveryService () <LFXLightCollectionObserver>
@property (nonatomic) NSMutableDictionary *lights;
@end


@implementation HKBLIFXDiscoveryService

- (void)startDiscovery
{
	[[[LFXClient sharedClient] localNetworkContext].allLightsCollection addLightCollectionObserver:self];
}

- (void)stopDiscovery
{
	[[[LFXClient sharedClient] localNetworkContext].allLightsCollection removeLightCollectionObserver:self];
}

- (void)addLightAccessory:(LFXLight *)lifxLight
{
	HKBLIFXLightAccessory *lightAccessory = self.lights[lifxLight.deviceID];
	
	if (!lightAccessory) {
		HKBLIFXLightAccessory *light = [[HKBLIFXLightAccessory alloc] initWithLightBulb:lifxLight];
		self.lights[lifxLight.deviceID] = light;
		
		[self.delegate discoveryService:self didDiscoverAccessory:light];
	}
}

- (void)removeLightAccessory:(LFXLight *)lifxLight
{
	HKBLIFXLightAccessory *lightAccessory = self.lights[lifxLight.deviceID];
	
	if(lightAccessory) {
		[self.lights removeObjectForKey:lifxLight.deviceID];
		
		[self.delegate discoveryService:self didLostAccessory:lightAccessory];
	}
}

#pragma mark LFXLightCollectionObserver

- (void)lightCollection:(LFXLightCollection *)lightCollection didAddLight:(LFXLight *)light
{
	[self addLightAccessory:light];
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didRemoveLight:(LFXLight *)light
{
	[self removeLightAccessory:light];
}

@end
