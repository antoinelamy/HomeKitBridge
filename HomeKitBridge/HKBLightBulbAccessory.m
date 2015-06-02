//
//  HKBLightAccessory.m
//  HomeKitBridge
//
//  Created by Kyle Howells on 11/10/2014.
//  Copyright (c) 2014 Kyle Howells. All rights reserved.
//

#import "HKBLightBulbAccessory.h"

@interface HKBLightBulbAccessory ()
@property (nonatomic) HAKService *lightBulbService;
@property (nonatomic) HKBLightCapabilities capabilities;
@end


@implementation HKBLightBulbAccessory

- (instancetype)initWithInformation:(HKBAccessoryInformation *)information
					   capabilities:(HKBLightCapabilities)capabilities
{
	self = [super initWithInformation:information];
	if (self) {
		self.capabilities = capabilities;
	}
	
	return self;
}

+ (HAKUUID *)lightBulbAccessoryServiceType
{
	return [HAKUUID UUIDWithUUIDString:@"00000043"];
}

+ (NSString *)lightBulbAccessoryServiceName
{
	return @"Lightbulb Service";
}

+ (HAKUUID *)brightnessCharacteristicType
{
	return [HAKUUID UUIDWithUUIDString:@"00000008-0000-1000-8000-0026BB765291"];
}

+ (HAKUUID *)hueCharacteristicType
{
	return [HAKUUID UUIDWithUUIDString:@"00000013-0000-1000-8000-0026BB765291"];
}

+ (HAKUUID *)saturationCharacteristicType
{
	return [HAKUUID UUIDWithUUIDString:@"0000002F-0000-1000-8000-0026BB765291"];
}

- (void)setupServices
{
	self.lightBulbService = [[HAKService alloc] initWithType:[[self class] lightBulbAccessoryServiceType] name:[[self class] lightBulbAccessoryServiceName]];
	
	if (self.capabilities & HKBLightCapabilityBrightness) {
		HAKCharacteristic *brightnessCharacteristic = [[HAKCharacteristic alloc] initWithType:[HKBLightBulbAccessory brightnessCharacteristicType]];
		[self.lightBulbService addCharacteristic:brightnessCharacteristic];
	}
	
	if (self.capabilities & HKBLightCapabilityHue) {
		HAKCharacteristic *hueCharacteristic = [[HAKCharacteristic alloc] initWithType:[HKBLightBulbAccessory hueCharacteristicType]];
		[self.lightBulbService addCharacteristic:hueCharacteristic];
	}

	if (self.capabilities & HKBLightCapabilitySaturation) {
		HAKCharacteristic *saturationCharacteristic = [[HAKCharacteristic alloc] initWithType:[HKBLightBulbAccessory saturationCharacteristicType]];
		[self.lightBulbService addCharacteristic:saturationCharacteristic];
	}
	
	[self.accessory addService:self.lightBulbService];
	
	[super setupServices];
}

- (HAKService *)switchService
{
	return self.lightBulbService;
}


#pragma mark - HomeKit Notification

- (void)characteristicDidUpdateValue:(HAKCharacteristic *)characteristic
{
	[super characteristicDidUpdateValue:characteristic];
	
	if(characteristic.service == self.lightBulbService) {
		
		if([characteristic.type isEqual:[HKBLightBulbAccessory brightnessCharacteristicType]]) {
			if ([self respondsToSelector:@selector(setBrightness:)]) {
				[self setBrightness:[characteristic.value integerValue]];
			}
		}
		
		if([characteristic.type isEqual:[HKBLightBulbAccessory saturationCharacteristicType]]) {
			if ([self respondsToSelector:@selector(setSaturation:)]) {
				[self setSaturation:[characteristic.value integerValue]];
			}
		}
		
		if([characteristic.type isEqual:[HKBLightBulbAccessory hueCharacteristicType]]) {
			if ([self respondsToSelector:@selector(setHue:)]) {
				[self setHue:[characteristic.value integerValue]];
			}
		}
	}
}


#pragma mark - HKBLightBulbObserverProtocol

- (void)brightnessUpdated:(NSInteger)brightness
{
	HAKCharacteristic *brightnessCharacteristic = [self.lightBulbService characteristicWithType:[HKBLightBulbAccessory brightnessCharacteristicType]];

	if([brightnessCharacteristic.constraints validateValue:@(brightness)]) {
		brightnessCharacteristic.value = @(brightness);
	}
	else {
		NSLog(@"Invalid value for characteristic %@", brightnessCharacteristic);
	}
}

- (void)saturationUpdated:(NSInteger)saturation
{
	HAKCharacteristic *saturationCharacteristic = [self.lightBulbService characteristicWithType:[HKBLightBulbAccessory saturationCharacteristicType]];

	if([saturationCharacteristic.constraints validateValue:@(saturation)]) {
		saturationCharacteristic.value = @(saturation);
	}
	else {
		NSLog(@"Invalid value for characteristic %@", saturationCharacteristic);
	}
}

- (void)hueUpdated:(NSInteger)hue
{
	HAKCharacteristic *hueCharacteristic = [self.lightBulbService characteristicWithType:[HKBLightBulbAccessory hueCharacteristicType]];

	if([hueCharacteristic.constraints validateValue:@(hue)]) {
		hueCharacteristic.value = @(hue);
	}
	else {
		NSLog(@"Invalid value for characteristic %@", hueCharacteristic);
	}
}

#pragma mark - HKBLightBulbControlProtocol

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
