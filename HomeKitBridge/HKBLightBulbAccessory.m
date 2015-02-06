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
	
	HAKAccessoryInformationService *infomationService = self.accessory.accessoryInformationService;
	
	// Setup the lightbulb
	self.lightBulbService = [[HAKLightBulbService alloc] init];
	
	// Name characteristic
	HAKNameCharacteristic *serviceName = [HAKNameCharacteristic new];
	serviceName.name = infomationService.nameCharacteristic.name;
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
	HAKBrightnessCharacteristic *bright = self.lightBulbService.brightnessCharacteristic;
	
	NSInteger min = [bright.minimumValue integerValue];
	NSInteger max = [bright.maximumValue integerValue];
	
	// Cap to min and max
	brightness = MIN(max, brightness);
	brightness = MAX(min, brightness);
	
	// Set it
	[bright setIntegerValue:brightness];
}

- (void)saturationUpdated:(NSInteger)saturation
{
	HAKSaturationCharacteristic *sat = self.lightBulbService.saturationCharacteristic;
	
	CGFloat min = [sat.minimumValue floatValue];
	CGFloat max = [sat.maximumValue floatValue];
	
	// Cap to min and max
	saturation = MIN(max, saturation);
	saturation = MAX(min, saturation);
	
	[sat setFloatValue:saturation];
}

- (void)hueUpdated:(NSInteger)hue
{
	HAKHueCharacteristic *hueChar = self.lightBulbService.hueCharacteristic;
	
	CGFloat min = [hueChar.minimumValue floatValue];
	CGFloat max = [hueChar.maximumValue floatValue];
	
	// Cap to min and max
	hue = MIN(max, hue);
	hue = MAX(min, hue);
	
	[hueChar setFloatValue:hue];
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
