//
//  HKBPowerSwitchAccessory.m
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-05-02.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import "HKBSwitchAccessory.h"
#import "HAKSwitchService.h"


@interface HKBSwitchAccessory ()
@property (nonatomic) HAKSwitchService *switchService;
@end


@implementation HKBSwitchAccessory

+ (HKBAccessoryInformation *)defaultInformation
{
	return [[HKBAccessoryInformation alloc] initWithName:@"Power Switch"
											manufacturer:@"Kyle Tech"
												   model:@"WiFi Power Switch v1.0"];
}

- (void)setupServices
{
	[super setupServices];
	
	self.switchService = [[HAKSwitchService alloc] init];
	
	HAKNameCharacteristic *serviceName = [HAKNameCharacteristic new];
	serviceName.name = self.accessory.accessoryInformationService.nameCharacteristic.name;
	[self.switchService setNameCharacteristic:serviceName];
	
	[self.accessory addService:self.switchService];
}

- (void)characteristicDidUpdateValue:(HAKCharacteristic*)characteristic
{
	[super characteristicDidUpdateValue:characteristic];
	
	if(characteristic.service == self.switchService) {
		if ([characteristic isKindOfClass:[HAKNameCharacteristic class]]) {
			HAKNameCharacteristic *nameCharacteristic = (HAKNameCharacteristic *)characteristic;
			[self setName:nameCharacteristic.name];
		}
		
		if ([characteristic isKindOfClass:[HAKOnCharacteristic class]]) {
			HAKOnCharacteristic *onCharacteristic = (HAKOnCharacteristic *)characteristic;
			[self setPowerState:onCharacteristic.boolValue];
		}
	}
}


#pragma mark - HKBSwitchObserverProtocol

- (void)nameUpdated:(NSString *)name
{
	[self.switchService.nameCharacteristic setStringValue:name];
}

- (void)powerStateUpdated:(BOOL)powerState
{
	[self.switchService.onCharacteristic setBoolValue:powerState];
}


#pragma mark - HKBSwitchControlProtocol

- (void)setName:(NSString *)name
{
	// Do nothing, implement in subclass
}

- (void)setPowerState:(BOOL)powerState
{
	// Do nothing, implement in subclass
}

@end
