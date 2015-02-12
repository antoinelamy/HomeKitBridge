//
//  HKBLightAccessory.m
//  HomeKitBridge
//
//  Created by Kyle Howells on 11/10/2014.
//  Copyright (c) 2014 Kyle Howells. All rights reserved.
//

#import "HKBLightBulbAccessory.h"

@interface HKBLightBulbAccessory ()
@property (nonatomic) HAKLightBulbService *lightBulbService;
@property (nonatomic) HKBLightCharacteristics characteristics;
@end


@implementation HKBLightBulbAccessory

- (instancetype)initWithInformation:(HKBAccessoryInformation *)information
				 characteristics:(HKBLightCharacteristics)characteristics
{
	self = [super initWithInformation:information];
	if (self) {
		self.characteristics = characteristics;
	}
	
	return self;
}

+ (HKBAccessoryInformation *)defaultInformation
{
	return [[HKBAccessoryInformation alloc] initWithName:@"Lightbulb"
											manufacturer:@"Kyle Tech"
												   model:@"WiFi Lightbulb v1.0"];
}

- (void)setupServices
{
	[super setupServices];
	
	// Setup the lightbulb
	self.lightBulbService = [[HAKLightBulbService alloc] init];
	
	// Name characteristic
	HAKNameCharacteristic *serviceName = [HAKNameCharacteristic new];
	serviceName.name = self.accessory.accessoryInformationService.nameCharacteristic.name;
	[self.lightBulbService setNameCharacteristic:serviceName];
	
	// If supports controlling brightness
	if (self.characteristics & HKBLightCharacteristicBrightness) {
		HAKBrightnessCharacteristic *brightnessCharacteristic = [[HAKBrightnessCharacteristic alloc] init];
		self.lightBulbService.brightnessCharacteristic = brightnessCharacteristic;
	}
	
	// If supports controlling Hue
	if (self.characteristics & HKBLightCharacteristicHue) {
		HAKHueCharacteristic *hueCharacteristic = [[HAKHueCharacteristic alloc] init];
		self.lightBulbService.hueCharacteristic = hueCharacteristic;
	}

	// If supports controlling Saturation
	if (self.characteristics & HKBLightCharacteristicSaturation) {
		HAKSaturationCharacteristic *saturationCharacteristic = [[HAKSaturationCharacteristic alloc] init];
		self.lightBulbService.saturationCharacteristic = saturationCharacteristic;
	}
	
	[self.accessory addService:self.lightBulbService];
}


#pragma mark - HomeKit Notification

- (void)characteristicDidUpdateValue:(HAKCharacteristic *)characteristic
{
	[super characteristicDidUpdateValue:characteristic];
	
	if(characteristic.service == self.lightBulbService) {
		if ([characteristic isKindOfClass:[HAKNameCharacteristic class]]) {
			HAKNameCharacteristic *nameCharacteristic = (HAKNameCharacteristic *)characteristic;
			[self setName:nameCharacteristic.name];
		}
		
		if ([characteristic isKindOfClass:[HAKOnCharacteristic class]]) {
			HAKOnCharacteristic *onCharacteristic = (HAKOnCharacteristic *)characteristic;
			[self setPowerState:onCharacteristic.boolValue];
		}
		
		if ([characteristic isKindOfClass:[HAKBrightnessCharacteristic class]]) {
			HAKBrightnessCharacteristic *brightnessCharacteristic = (HAKBrightnessCharacteristic*)characteristic;
			if ([self respondsToSelector:@selector(setBrightness:)]) {
				[self setBrightness:brightnessCharacteristic.brightness];
			}
		}
		
		if ([characteristic isKindOfClass:[HAKSaturationCharacteristic class]]) {
			HAKSaturationCharacteristic *saturationCharacteristic = (HAKSaturationCharacteristic*)characteristic;
			if ([self respondsToSelector:@selector(setSaturation:)]) {
				[self setSaturation:saturationCharacteristic.saturation];
			}
		}
		
		if ([characteristic isKindOfClass:[HAKHueCharacteristic class]]) {
			HAKHueCharacteristic *hueCharacteristic = (HAKHueCharacteristic*)characteristic;
			if ([self respondsToSelector:@selector(setHue:)]) {
				[self setHue:hueCharacteristic.hue];
			}
		}
	}
}


#pragma mark - HKBLightBulbObserverProtocol

- (void)nameUpdated:(NSString *)name
{
	[self.lightBulbService.nameCharacteristic setStringValue:name];
}

- (void)powerStateUpdated:(BOOL)powerState
{
	[self.lightBulbService.onCharacteristic setBoolValue:powerState];
}

- (void)brightnessUpdated:(NSInteger)brightness
{
	HAKBrightnessCharacteristic *brightnessCharacteristic = self.lightBulbService.brightnessCharacteristic;
	
	brightness = MIN([brightnessCharacteristic.maximumValue integerValue], brightness);
	brightness = MAX([brightnessCharacteristic.minimumValue integerValue], brightness);
	
	[brightnessCharacteristic setIntegerValue:brightness];
}

- (void)saturationUpdated:(NSInteger)saturation
{
	HAKSaturationCharacteristic *saturationCharacteristic = self.lightBulbService.saturationCharacteristic;
	
	saturation = MIN([saturationCharacteristic.maximumValue floatValue], saturation);
	saturation = MAX([saturationCharacteristic.minimumValue floatValue], saturation);
	
	[saturationCharacteristic setFloatValue:saturation];
}

- (void)hueUpdated:(NSInteger)hue
{
	HAKHueCharacteristic *hueCharacteristic = self.lightBulbService.hueCharacteristic;
	
	hue = MIN([hueCharacteristic.maximumValue floatValue], hue);
	hue = MAX([hueCharacteristic.minimumValue floatValue], hue);
	
	[hueCharacteristic setFloatValue:hue];
}

#pragma mark - HKBLightBulbControlProtocol

- (void)setName:(NSString *)name
{
	// Do nothing, implement in subclass
}

- (void)setPowerState:(BOOL)powerState
{
	// Do nothing, implement in subclass
}

- (void)setBrightness:(NSInteger)brightness
{
	// Do nothing, implement in subclass
}

- (void)setSaturation:(NSInteger)saturation
{
	// Do nothing, implement in subclass
}

- (void)setHue:(NSInteger)hue
{
	// Do nothing, implement in subclass
}

@end
