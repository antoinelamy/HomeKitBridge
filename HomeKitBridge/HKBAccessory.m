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

@end


@implementation HKBAccessory

- (instancetype)initWithInformation:(HKBAccessoryInformation *)information
{
	self = [super init];
	if (self) {
		self.accessory = [[HAKAccessory alloc] init];
		self.setupInformation = information;
		
		[self setupServices]; // Subclass customisation point
		[self activateAccessory];
		
		// TODO: Proper Characteristic notification monitoring
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

	HAKAccessoryInformationService *infoService = [[HAKAccessoryInformationService alloc] init];
	infoService.nameCharacteristic.name = self.setupInformation.name ?: defaultInformation.name;
	infoService.manufacturerCharacteristic.manufacturer = self.setupInformation.manufacturer ?: defaultInformation.manufacturer;
	infoService.modelCharacteristic.model = self.setupInformation.model ?: defaultInformation.model;
	infoService.serialNumberCharacteristic.serialNumber = self.setupInformation.serialNumber;
	
	[self.accessory addService:infoService];
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

- (void)characteristicDidUpdateValueNotification:(NSNotification *)aNote
{
	HAKCharacteristic *characteristic = aNote.object;
	
	// If this notification is about us
	if ([characteristic.service.accessory isEqual:self.accessory]) {
		// Send the message off to the main thread, latency isn't an issue as this command has already made a network call.
		dispatch_async(dispatch_get_main_queue(), ^{
			[self characteristicDidUpdateValue:characteristic];
		});
	}
}

- (void)characteristicDidUpdateValue:(HAKCharacteristic *)characteristic
{
	// Do nothing, implement in subclass
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

@end
