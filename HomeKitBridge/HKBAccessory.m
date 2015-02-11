//
//  HKBAccessory.m
//  HomeKitBridge
//
//  Created by Kyle Howells on 11/10/2014.
//  Copyright (c) 2014 Kyle Howells. All rights reserved.
//

#import "HKBAccessory.h"
#import "HKBTransportManagerBuilder.h"

@interface HKBAccessory ()
@property (nonatomic) HAKAccessory *accessory;
@property (nonatomic) HKBAccessoryInformation *information;
@property (nonatomic) HKBAccessoryInformation *setupInformation;
@property (nonatomic) HAKTransportManager *transportManager;
@property (nonatomic) HAKAccessoryInformationService *informationService;
@end


@implementation HKBAccessory

- (instancetype)initWithInformation:(HKBAccessoryInformation *)information
{
	self = [super init];
	if (self) {
		self.accessory = [[HAKAccessory alloc] init];
		self.setupInformation = information;
		
		[self setupServices];
		[self activateAccessory];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(characteristicDidUpdateValueNotification:) name:@"HAKCharacteristicDidUpdateValueNotification" object:nil];
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (HKBAccessoryInformation *)defaultInformation
{
	return [HKBAccessoryInformation new];
}

- (void)setupServices
{
	HKBAccessoryInformation *defaultInformation = [[self class] defaultInformation];

	self.informationService = [[HAKAccessoryInformationService alloc] init];
	self.informationService.nameCharacteristic.name = self.setupInformation.name ?: defaultInformation.name;
	self.informationService.manufacturerCharacteristic.manufacturer = self.setupInformation.manufacturer ?: defaultInformation.manufacturer;
	self.informationService.modelCharacteristic.model = self.setupInformation.model ?: defaultInformation.model;
	self.informationService.serialNumberCharacteristic.serialNumber = self.setupInformation.serialNumber;
	
	[self.accessory addService:self.informationService];
}

- (void)activateAccessory
{
	HAKAccessoryInformationService *informationService = [self.accessory accessoryInformationService];
	NSString *name = [informationService nameCharacteristic].name;
	NSString *serialNumber = [informationService serialNumberCharacteristic].serialNumber;
	
	self.transportManager = [HKBTransportManagerBuilder transportManagerForSerialNumber:serialNumber];
	[self.transport addAccessory:self.accessory];
	
	NSLog(@"Transport: %@", self.transport);
	NSLog(@"Password: %@", self.transport.password);
	
	[self.transportManager setName:name];
	[self.transport setName:name];
	
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
	if(characteristic.service == self.informationService) {
		if ([characteristic isKindOfClass:[HAKNameCharacteristic class]]) {
			HAKNameCharacteristic *nameCharacteristic = (HAKNameCharacteristic *)characteristic;
			[self nameUpdated:nameCharacteristic.name];
		}
	}
}

#pragma mark - Property Getters

- (HAKTransport *)transport
{
	return [self.transportManager.transports firstObject];
}

- (NSString *)name
{
	return self.accessory.accessoryInformationService.nameCharacteristic.name;
}

- (NSString *)passcode
{
	return self.transport.password;
}

#pragma mark - HKBAccessoryObserverProtocol

- (void)nameUpdated:(NSString *)name
{
	[self.informationService.nameCharacteristic setStringValue:name];
}

#pragma mark - HKBAccessoryControlProtocol

- (void)setName:(NSString *)name
{
	// Do nothing, implement in subclass
}

@end
