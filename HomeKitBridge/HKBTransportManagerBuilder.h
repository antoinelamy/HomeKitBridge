//
//  HKBTransportManagerBuilder.h
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-04-02.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAKAccessoryKit.h"

@interface HKBTransportManagerBuilder : NSObject

+ (HAKTransportManager *)transportManagerForSerialNumber:(NSString *)serialNumber;

@end
