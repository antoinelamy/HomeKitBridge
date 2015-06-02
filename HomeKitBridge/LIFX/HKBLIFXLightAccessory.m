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

- (instancetype)initWithLightBulb:(LFXLight*)lightBulb
{
	HKBLightCapabilities lightCapabilities = (HKBLightCapabilityBrightness | HKBLightCapabilityHue | HKBLightCapabilitySaturation);
	
	HKBAccessoryInformation *information = [[HKBAccessoryInformation alloc] initWithName:[lightBulb.label length] > 0 ? lightBulb.label : @"LIFX multi-color LED bulb"
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


// TODO: work out how to define custom characteristics and add the kelvin value of LIFX bulbs
//-(void)setupServices{
//	[super setupServices];
//	
//	HAKIntegerCharacteristic *kelvin = [[HAKIntegerCharacteristic alloc] init];
//	kelvin.minimumValue = [NSNumber numberWithInt:LFXHSBKColorMinKelvin];
//	kelvin.maximumValue = [NSNumber numberWithInt:LFXHSBKColorMaxKelvin];
//	[self.lightBulbService addCharacteristic:kelvin];
//}


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
}


#pragma mark - HKBLightBulbControlProtocol

- (void)setName:(NSString *)name
{
	[self.lifxBulb setLabel:name];
}

- (void)setPowerState:(BOOL)powerState
{
	[self.lifxBulb setPowerState:powerState ? LFXPowerStateOn : LFXPowerStateOff];
}

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

@end
