//
//  HKBLightAccessoryLIFX.h
//  HomeKitBridge
//
//  Created by Kyle Howells on 13/10/2014.
//  Copyright (c) 2014 Kyle Howells. All rights reserved.
//

#import "HKBLightBulbAccessory.h"

@class LFXLight;


@protocol HKBLIFXLightBulbControlProtocol <HKBLightBulbControlProtocol>
- (void)setKelvin:(uint16_t)kelvin; // 2500-9000
@end


@protocol HKBLIFXLightBulbObserverProtocol <HKBLightBulbObserverProtocol>
- (void)kelvinUpdated:(NSUInteger)kelvin
@end


@interface HKBLIFXLightAccessory : HKBLightBulbAccessory <HKBLightBulbControlProtocol, HKBLightBulbObserverProtocol>

+ (HAKUUID *)kelvinCharacteristicType

- (instancetype)initWithInformation:(HKBAccessoryInformation *)information
					characteristics:(HKBLightCapabilities)characteristics NS_UNAVAILABLE;

- (instancetype)initWithLightBulb:(LFXLight *)lightBulb;

@end
