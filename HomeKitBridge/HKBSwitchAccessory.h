//
//  HKBPowerSwitchAccessory.h
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-05-02.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import "HKBAccessory.h"

@protocol HKBSwitchControlProtocol <NSObject>
@required
- (void)setName:(NSString *)name;
- (void)setPowerState:(BOOL)powerState;
@end


@protocol HKBSwitchObserverProtocol <NSObject>
@required
- (void)nameUpdated:(NSString *)name;
- (void)powerStateUpdated:(BOOL)powerState;
@end


@interface HKBSwitchAccessory : HKBAccessory <HKBSwitchControlProtocol, HKBSwitchObserverProtocol>

@end
