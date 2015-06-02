//
//  HKBPowerSwitchAccessory.h
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-05-02.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import "HKBAccessory.h"

@protocol HKBSwitchControlProtocol <HKBAccessoryControlProtocol>
@required
- (void)setPowerState:(BOOL)powerState;
@end


@protocol HKBSwitchObserverProtocol <HKBAccessoryObserverProtocol>
@required
- (void)powerStateUpdated:(BOOL)powerState;
@end


@interface HKBSwitchAccessory : HKBAccessory <HKBSwitchControlProtocol, HKBSwitchObserverProtocol>

+ (HAKUUID *)powerStateCharacteristicType;

- (HAKService *)switchService;

@end
