//
//  HKBDiscoveryService.h
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-12-03.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKBAccessory.h"

@protocol HKBDiscoveryServiceDelegate;


@interface HKBDiscoveryService : NSObject

@property (nonatomic, weak) id<HKBDiscoveryServiceDelegate> delegate;

- (void)startDiscovery;
- (void)stopDiscovery;
- (BOOL)isDiscovering;

@end


@protocol HKBDiscoveryServiceDelegate <NSObject>

- (void)discoveryService:(HKBDiscoveryService *)service didDiscoverAccessory:(HKBAccessory *)accessory;
- (void)discoveryService:(HKBDiscoveryService *)service didLostAccessory:(HKBAccessory *)accessory;

@end
