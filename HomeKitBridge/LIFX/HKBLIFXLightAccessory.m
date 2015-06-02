//
//  HKBLightAccessoryLIFX.m
//  HomeKitBridge
//
//  Created by Kyle Howells on 13/10/2014.
//  Copyright (c) 2014 Kyle Howells. All rights reserved.
//

#import "HKBLIFXLightAccessory.h"

#import <LIFXKit/LIFXKit.h>


@interface HKBLIFXLightAccessory () <LFXLightObserver>
@property (nonatomic) LFXLight *lifxBulb;
@end


@implementation HKBLIFXLightAccessory

- (instancetype)initWithLightBulb:(LFXLight *)lightBulb
{
	HKBLightCapabilities lightCapabilities = (HKBLightCapabilityBrightness | HKBLightCapabilityHue | HKBLightCapabilitySaturation);
	
	NSString *lightBulbName = [lightBulb.label length] > 0 ? lightBulb.label : @"LIFX multi-color LED bulb";
	HKBAccessoryInformation *information = [[HKBAccessoryInformation alloc] initWithName:lightBulbName
																			manufacturer:@"LIFX"
																				   model:@"17W Wi-Fi LED smart bulb"
																			serialNumber:lightBulb.deviceID];
	
	if (self = [super initWithInformation:information capabilities:lightCapabilities]) {
		self.lifxBulb = lightBulb;
		[self setupServices];
		
		// Initial values
		[self light:self.lifxBulb didChangeColor:self.lifxBulb.color];
		[self light:self.lifxBulb didChangePowerState:self.lifxBulb.powerState];
		[self light:self.lifxBulb didChangeLabel:self.lifxBulb.label];
		
		[self.lifxBulb addLightObserver:self];
	}
	
	return self;
}

- (void)dealloc
{
	[self.lifxBulb removeLightObserver:self];
}

+ (HAKUUID *)kelvinCharacteristicType
{
	return [HAKUUID UUIDWithUUIDString:@"0836D660-26E5-4D17-A714-A15DB6EAC9A5"];
}

-(void)setupServices
{
	[super setupServices];
	
	HAKCharacteristic *kelvinCharacteristic = [[HAKCharacteristic alloc] initWithType:[[self class] kelvinCharacteristicType]];
	HAKNumberConstraints *kelvinNumberConstraints = [[HAKNumberConstraints alloc] initWithMinimumValue:@(LFXHSBKColorMinKelvin) maximumValue:@(LFXHSBKColorMaxKelvin)];
	kelvinCharacteristic.constraints = kelvinNumberConstraints;
	[self.lightBulbService addCharacteristic:kelvinCharacteristic];
}

- (void)characteristicDidUpdateValue:(HAKCharacteristic *)characteristic
{
	[super characteristicDidUpdateValue:characteristic];
	
	if(characteristic.service == self.lightBulbService) {
		if([characteristic.type isEqual:[HKBLIFXLightAccessory kelvinCharacteristicType]]) {
			if ([self respondsToSelector:@selector(setKelvin:)]) {
				[self setKelvin:[characteristic.value unsignedIntValue]];
			}
		}
	}
}


#pragma mark - Observer protocols

#pragma mark HKBLIFXLightBulbObserverProtocol

- (void)kelvinUpdated:(NSUInteger)kelvin
{
	HAKCharacteristic *kelvinCharacteristic = [self.lightBulbService characteristicWithType:[HKBLIFXLightAccessory kelvinCharacteristicType]];
	
	if([kelvinCharacteristic.constraints validateValue:@(kelvin)]) {
		kelvinCharacteristic.value = @(kelvin);
	}
	else {
		NSLog(@"Invalid value for characteristic %@", kelvinCharacteristic);
	}
}

#pragma mark - Control protocols

#pragma mark HKBAccessoryControlProtocol

- (void)setName:(NSString *)name
{
	[self.lifxBulb setLabel:name];
}

#pragma mark HKBSwitchControlProtocol

- (void)setPowerState:(BOOL)powerState
{
	[self.lifxBulb setPowerState:powerState ? LFXPowerStateOn : LFXPowerStateOff];
}

#pragma mark HKBLightBulbControlProtocol

- (void)setBrightness:(NSInteger)brightness
{
	LFXHSBKColor *currentColor = [self.lifxBulb color];
	LFXHSBKColor *newColor = [LFXHSBKColor colorWithHue:currentColor.hue saturation:currentColor.saturation brightness:brightness * 0.01]; // Why 0.01??
	[self.lifxBulb setColor:newColor];
}

- (void)setSaturation:(NSInteger)saturation
{
	LFXHSBKColor *currentColor = [self.lifxBulb color];
	LFXHSBKColor *newColor = [LFXHSBKColor colorWithHue:currentColor.hue saturation:saturation * 0.01 brightness:currentColor.brightness];
	[self.lifxBulb setColor:newColor];
}

- (void)setHue:(NSInteger)hue
{
	LFXHSBKColor *currentColor = [self.lifxBulb color];
	LFXHSBKColor *newColor = [LFXHSBKColor colorWithHue:hue saturation:currentColor.saturation brightness:currentColor.brightness];
	[self.lifxBulb setColor:newColor];
}

#pragma mark HKBLIFXLightBulbControlProtocol

- (void)setKelvin:(uint16_t)kelvin
{
	LFXHSBKColor *currentColor = [self.lifxBulb color];
	LFXHSBKColor *newColor = [LFXHSBKColor colorWithHue:currentColor.hue saturation:currentColor.saturation brightness:currentColor.brightness kelvin:kelvin];
	[self.lifxBulb setColor:newColor];
}


#pragma mark - LFXLightObserver

- (void)light:(LFXLight *)light didChangeLabel:(NSString *)label
{
	[self nameUpdated:label];
}

- (void)light:(LFXLight *)light didChangePowerState:(LFXPowerState)powerState
{
	[self powerStateUpdated:(self.lifxBulb.powerState == LFXPowerStateOn)];
}

- (void)light:(LFXLight *)light didChangeColor:(LFXHSBKColor *)color
{
	// - Conversion:	LIFX		HomeKit
	// hue;			//	[0, 360] -  [0, 360]
	// saturation;	//	[0, 1]	 -  [0, 100]
	// brightness;	//	[0, 1]	 -  [0, 100]
	
	[self brightnessUpdated:(self.lifxBulb.color.brightness * 100)];
	[self saturationUpdated:(self.lifxBulb.color.saturation * 100)];
	[self hueUpdated:self.lifxBulb.color.hue];
	[self kelvinUpdated:self.lifxBulb.color.kelvin];
}

@end
