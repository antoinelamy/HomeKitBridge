//
//  HKBTransportManagerBuilder.m
//  HomeKitBridge
//
//  Created by Antoine Lamy on 2015-04-02.
//  Copyright (c) 2015 Kyle Howells. All rights reserved.
//

#import "HKBTransportManagerBuilder.h"

@implementation HKBTransportManagerBuilder

+ (HAKTransportManager *)transportManagerForSerialNumber:(NSString *)serialNumber
{
	NSString *filename = [serialNumber stringByAppendingString:@".plist"];
	NSURL *cacheFile = [[self cacheFolderURL] URLByAppendingPathComponent:filename];
	
	HAKTransportManager *transportManager = nil;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:[cacheFile path]]) {
		transportManager = [[HAKTransportManager alloc] initWithURL:cacheFile];
		NSLog(@"Recovered transport manager: %@", transportManager);
	}
	
	// Loading the file failed
	if (transportManager == nil) {
		HAKIPTransport *transport = [HAKIPTransport new];
		
		// Can we cache just the HAKTransportManager and kick out all the services first?
		transportManager = [HAKTransportManager new];
		[transportManager addTransport:transport];
		
		NSLog(@"Created new Transport Manager: %@", transportManager);
		
		[transport password]; // This init's the pass without this it breaks
		[transportManager writeToURL:cacheFile atomically:YES];
	}
	
	return transportManager;
}


+ (NSURL *)cacheFolderURL
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *appFolder = [[fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil] URLByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
	
	if ([fileManager fileExistsAtPath:[appFolder path]] == NO) {
		[fileManager createDirectoryAtPath:[appFolder path] withIntermediateDirectories:NO attributes:nil error:nil];
	}
	
	return appFolder;
}

@end
