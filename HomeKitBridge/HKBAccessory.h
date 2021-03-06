//
//  HKBAccessory.h
//  HomeKitBridge
//
//  Created by Kyle Howells on 11/10/2014.
//  Copyright (c) 2014 Kyle Howells. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HAKAccessoryKit.h"
#import "HKBAccessoryInformation.h"


@protocol HKBAccessoryControlProtocol <NSObject>
@required
- (void)setName:(NSString *)name;
@end


@protocol HKBAccessoryObserverProtocol <NSObject>
@required
- (void)nameUpdated:(NSString *)name;
@end


/**
 *  Base class for bridged accessories. Includes all the boilerplate setup code, allowing subclasses to focus on specific implementations.
 *
 *  Subclasses should override the methods in the (Subclasses) category definition.
 */
@interface HKBAccessory : NSObject <HKBAccessoryControlProtocol, HKBAccessoryObserverProtocol>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithInformation:(HKBAccessoryInformation *)information;


/**
 *  Returns the HomeKit accessory for this Bridged accessory.
 */
@property (nonatomic, readonly) HAKAccessory *accessory;

/**
 *  Returns the accessory information.
 */
@property (nonatomic, readonly) HKBAccessoryInformation *information;

/**
 *  The passcode to connect to it
 */
@property (nonatomic, readonly) NSString *passcode;

/**
 *  Add services to the accessory here. NOTE: Must call super.
 */
- (void)setupServices;

/**
 *  Updates received are sent to this method.
 *
 *  @param characteristic The HAKCharacteristic that changed.
 */
- (void)characteristicDidUpdateValue:(HAKCharacteristic *)characteristic;

@end
