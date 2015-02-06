//
//  HKBLightAccessoryLIFX.h
//  HomeKitBridge
//
//  Created by Kyle Howells on 13/10/2014.
//  Copyright (c) 2014 Kyle Howells. All rights reserved.
//

#import "HKBLightBulbAccessory.h"

@class LFXLight;


@interface HKBLightAccessoryLIFX : HKBLightBulbAccessory

// Remove old init method
- (instancetype)initWithInformation:(HKBAccessoryInformation *)information characteristics:(HKBLightCharacteristics)characteristics NS_UNAVAILABLE;

/**
 *  Creates an accessory lightbulb object to match a LIFX bulb
 *
 *  @param lightBulb The LIFX bulbs API object for that light.
 */
- (instancetype)initWithLightBulb:(LFXLight *)lightBulb;

@end
