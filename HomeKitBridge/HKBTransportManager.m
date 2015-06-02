//
//  HKBTransportManagerBuilder.m
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-04-02.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import "HKBTransportManager.h"
#import "HAKIPTransport.h"

@implementation HKBTransportManager

+ (HAKTransport *)transportForSerialNumber:(NSString *)serialNumber
{
	NSString *filename = [serialNumber stringByAppendingString:@".plist"];
	NSURL *cacheFile = [[self cacheFolderURL] URLByAppendingPathComponent:filename];
	
	HAKTransport *transport = [NSKeyedUnarchiver unarchiveObjectWithFile:[cacheFile path]];
	
	if (!transport) {
		HAKIPTransport *transport = [[HAKIPTransport alloc] init];
		[transport password]; // This init's the pass without this it breaks
		
		[NSKeyedArchiver archiveRootObject:transport toFile:[cacheFile path]];
	}

	return transport;
}


+ (NSURL *)cacheFolderURL
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *supportDirectoryURL = [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
	NSURL *appFolder = [supportDirectoryURL URLByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
	
	if(![fileManager fileExistsAtPath:[appFolder path]]) {
		[fileManager createDirectoryAtPath:[appFolder path] withIntermediateDirectories:NO attributes:nil error:nil];
	}
	
	return appFolder;
}

@end
