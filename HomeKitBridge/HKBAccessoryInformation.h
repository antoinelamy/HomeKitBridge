//
//  HKBAccessoryInformation.h
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-04-02.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKBAccessoryInformation : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *manufacturer;
@property (nonatomic, readonly) NSString *model;
@property (nonatomic, readonly) NSString *serialNumber;

- (instancetype)initWithName:(NSString *)name
				manufacturer:(NSString *)manufacturer
					   model:(NSString *)model;

- (instancetype)initWithName:(NSString *)name
				manufacturer:(NSString *)manufacturer
					   model:(NSString *)model
				serialNumber:(NSString *)serialNumber;

@end
