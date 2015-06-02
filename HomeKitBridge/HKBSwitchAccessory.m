//
//  HKBPowerSwitchAccessory.m
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-05-02.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import "HKBSwitchAccessory.h"
#import "HAKService.h"


@interface HKBSwitchAccessory ()
@property (nonatomic) HAKService *switchService;
@end


@implementation HKBSwitchAccessory

+ (HAKUUID *)switchAccessoryServiceType
{
	return [HAKUUID UUIDWithUUIDString:@"00000049"];
}

+ (NSString *)switchAccessoryServiceName
{
	return @"Switch Service";
}

+ (HAKUUID *)powerStateCharacteristicType;
{
	return [HAKUUID UUIDWithUUIDString:@"00000025-0000-1000-8000-0026BB765291"];
}

- (void)setupServices
{
	if(!self.switchService) {
		self.switchService = [[HAKService alloc] initWithType:[[self class] switchAccessoryServiceType] name:[[self class] switchAccessoryServiceName]];
		
		HAKCharacteristic *powerStateCharacteristic = [[HAKCharacteristic alloc] initWithType:[HKBSwitchAccessory powerStateCharacteristicType]];
		[self.switchService addCharacteristic:powerStateCharacteristic];
		[self.accessory addService:self.switchService];
	}
	
	[super setupServices];
}

- (void)characteristicDidUpdateValue:(HAKCharacteristic *)characteristic
{
	[super characteristicDidUpdateValue:characteristic];
	
	if(characteristic.service == self.switchService) {
		if ([characteristic.type isEqual:[HKBSwitchAccessory powerStateCharacteristicType]]) {
			[self setPowerState:[characteristic.value boolValue]];
		}
	}
}


#pragma mark - HKBSwitchObserverProtocol

- (void)powerStateUpdated:(BOOL)powerState
{
	HAKCharacteristic *powerStateCharacteristic = [self.switchService characteristicWithType:[HKBSwitchAccessory powerStateCharacteristicType]];
	powerStateCharacteristic.value = @(powerState);
}


#pragma mark - HKBSwitchControlProtocol

- (void)setPowerState:(BOOL)powerState
{
	// Do nothing, implement in subclass
}

@end
