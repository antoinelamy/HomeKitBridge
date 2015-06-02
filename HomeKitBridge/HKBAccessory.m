//
//  HKBAccessory.m
//  HomeKitBridge
//
//  Created by Kyle Howells on 11/10/2014.
//  Copyright (c) 2014 Kyle Howells. All rights reserved.
//

#import "HKBAccessory.h"
#import "HKBTransportManager.h"
#import "HAKNetService.h"

@interface HKBAccessory ()
@property (nonatomic) HAKAccessory *accessory;
@property (nonatomic) HKBAccessoryInformation *information;
@property (nonatomic) HAKTransport *transport;
@end


@implementation HKBAccessory

- (instancetype)initWithInformation:(HKBAccessoryInformation *)information
{
	self = [super init];
	if (self) {
		self.information = information;
		
		self.accessory = [[HAKAccessory alloc] init];
		self.accessory.name = information.name;
		self.accessory.manufacturer = information.manufacturer;
		self.accessory.model = information.model;
		self.accessory.serialNumber = information.serialNumber;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(characteristicDidUpdateValueNotification:) name:@"HAKCharacteristicDidUpdateValueNotification" object:nil];
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupServices
{
	[self setupTransport];
}

- (void)setupTransport
{
	self.transport = [HKBTransportManager transportForSerialNumber:self.information.serialNumber];
	[self.transport addAccessory:self.accessory];
	
	[self.transport start];
}

#pragma mark - Notifications

- (void)characteristicDidUpdateValueNotification:(NSNotification *)notification
{
	HAKCharacteristic *characteristic = notification.object;
	
	if ([characteristic.service.accessory isEqual:self.accessory]) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self characteristicDidUpdateValue:characteristic];
		});
	}
}

- (void)characteristicDidUpdateValue:(HAKCharacteristic *)characteristic
{
	if(characteristic.service == self.accessory.accessoryInformationService) {
		if(characteristic == self.accessory.accessoryInformationService.nameCharacteristic) {
			[self setName:characteristic.value];
		}
	}
}

#pragma mark - Property Getters

- (NSString *)name
{
	return self.accessory.name;
}

- (NSString *)passcode
{
	return self.transport.password;
}

#pragma mark - HKBAccessoryObserverProtocol

- (void)nameUpdated:(NSString *)name
{
	[self.accessory.accessoryInformationService.nameCharacteristic setValue:name];
}

#pragma mark - HKBAccessoryControlProtocol

- (void)setName:(NSString *)name
{
	// Do nothing, implement in subclass
}

@end
