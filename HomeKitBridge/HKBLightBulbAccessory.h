//
//  HKBLightAccessory.h
//  HomeKitBridge
//
//  Created by Kyle Howells on 11/10/2014.
//  Copyright (c) 2014 Kyle Howells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKBSwitchAccessory.h"

@class HKBLightBulbAccessory;


typedef NS_OPTIONS(NSInteger, HKBLightCapabilities) {
	HKBLightCapabilityHue =			1 << 0,
	HKBLightCapabilitySaturation =	1 << 1,
	HKBLightCapabilityBrightness =	1 << 2
};


@protocol HKBLightBulbControlProtocol <HKBSwitchControlProtocol>
@optional
- (void)setBrightness:(NSInteger)brightness; // 0-100
- (void)setSaturation:(NSInteger)saturation; // 0-100
- (void)setHue:(NSInteger)hue; // 0-360
@end


@protocol HKBLightBulbObserverProtocol <HKBSwitchObserverProtocol>
@optional
- (void)brightnessUpdated:(NSInteger)brightness;
- (void)saturationUpdated:(NSInteger)saturation;
- (void)hueUpdated:(NSInteger)hue;
@end


@interface HKBLightBulbAccessory : HKBSwitchAccessory <HKBLightBulbControlProtocol, HKBLightBulbObserverProtocol>

+ (HAKUUID *)brightnessCharacteristicType;
+ (HAKUUID *)hueCharacteristicType;
+ (HAKUUID *)saturationCharacteristicType;

- (instancetype)initWithInformation:(HKBAccessoryInformation *)information NS_UNAVAILABLE;

- (instancetype)initWithInformation:(HKBAccessoryInformation *)information
					   capabilities:(HKBLightCapabilities)capabilities;

@end

