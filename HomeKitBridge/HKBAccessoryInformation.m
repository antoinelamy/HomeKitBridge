//
//  HKBAccessoryInformation.m
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-04-02.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import "HKBAccessoryInformation.h"

@interface HKBAccessoryInformation ()
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *manufacturer;
@property (nonatomic) NSString *model;
@property (nonatomic) NSString *serialNumber;
@end


@implementation HKBAccessoryInformation

- (instancetype)init
{
	return [self initWithName:@"Accessory" manufacturer:@"Kyle Tech" model:@"Accessory v1.0" serialNumber:nil];
}

- (instancetype)initWithName:(NSString *)name
				manufacturer:(NSString *)manufacturer
					   model:(NSString *)model
{
	return [self initWithName:name manufacturer:manufacturer model:model serialNumber:nil];
}

- (instancetype)initWithName:(NSString *)name
				manufacturer:(NSString *)manufacturer
					   model:(NSString *)model
				serialNumber:(NSString *)serialNumber
{
	self = [super init];
	if(self) {
		self.name = name;
		self.model = model;
		self.manufacturer = manufacturer;
		self.serialNumber = serialNumber;
	}
	return self;
}

@end
