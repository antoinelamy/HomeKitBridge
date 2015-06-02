//
//  HKBAccessoryInformation.m
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-04-02.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import "HKBAccessoryInformation.h"

@implementation HKBAccessoryInformation

- (instancetype)initWithName:(NSString *)name
				manufacturer:(NSString *)manufacturer
					   model:(NSString *)model
				serialNumber:(NSString *)serialNumber
{
	self = [super init];
	if(self) {
		_name = name;
		_model = model;
		_manufacturer = manufacturer;
		_serialNumber = serialNumber;
	}
	return self;
}

@end
