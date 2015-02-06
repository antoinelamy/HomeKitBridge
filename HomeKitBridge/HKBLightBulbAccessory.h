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


typedef NS_OPTIONS(NSInteger, HKBLightCharacteristics) {
	HKBLightCharacteristicHue =			1 << 0,
	HKBLightCharacteristicSaturation =	1 << 1,
	HKBLightCharacteristicBrightness =	1 << 2
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


@interface HKBLightBulbAccessory : HKBAccessory <HKBLightBulbControlProtocol, HKBLightBulbObserverProtocol>

- (instancetype)initWithInformation:(HKBAccessoryInformation *)information NS_UNAVAILABLE;

/**
 *  Create a new accessory with the supplied device information. If a key is missing the default information for that key will be used. "serialNumber" is a required key and will not be subsituted.
 *
 *  @param information Keys: "name", "serialNumber", "manufacturer", "model"
 *  @param characteristics The abilities the light has, an combo of: brightness, hue and saturation.
 */
- (instancetype)initWithInformation:(HKBAccessoryInformation *)information
					characteristics:(HKBLightCharacteristics)characteristics;

@property (nonatomic, readonly) HKBLightCharacteristics characteristics;

@end

