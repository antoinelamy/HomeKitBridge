//
//  AppDelegate.m
//  HomeKitBridge
//
//  Created by Kyle Howells on 11/10/2014.
//  Copyright (c) 2014 Kyle Howells. All rights reserved.
//

#import "AppDelegate.h"
#import "HKBSupportedAccessories.h"

@interface AppDelegate () <HKBDiscoveryServiceDelegate>

@property (weak) IBOutlet NSWindow *window; // Window left in case I want to add UI at any point

@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic) NSMenu *lightsMenu;

@property (nonatomic) NSArray *discoveryServices;
@property (nonatomic) NSMutableArray *accessories;

- (NSMenuItem *)createMenuItemForAccessory:(HKBAccessory *)_accessory;
- (NSMenuItem *)menuItemForAccessory:(HKBAccessory *)_accessory;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self setupMenu];
	[self setupDiscoveryServices];
	[self startDiscovery];
}

- (void)setupMenu
{
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	self.statusItem.title = @"HKB"; // HKB = HomeKit Bridge
	self.statusItem.highlightMode = YES;
	self.statusItem.menu = [[NSMenu alloc] init];
	
	NSMenuItem *lightsMenuItem = [[NSMenuItem alloc] init];
	lightsMenuItem.title = @"Lights";
	
	self.lightsMenu = [[NSMenu alloc] init];
	lightsMenuItem.submenu = self.lightsMenu;
	
	[self.statusItem.menu addItem:lightsMenuItem];
}

- (void)setupDiscoveryServices
{
	NSMutableArray *discoveryServices = [NSMutableArray array];
	for(Class discoveryServiceClass in [HKBSupportedAccessories supportedDiscoveryServices]) {
		HKBDiscoveryService *discoveryService = [[discoveryServiceClass alloc] init];
		discoveryService.delegate = self;
		[discoveryServices addObject:discoveryService];
	}
	self.accessories = [NSMutableArray array];
	self.discoveryServices = [NSArray arrayWithArray:discoveryServices];
}

- (NSMenuItem *)createMenuItemForAccessory:(HKBAccessory *)accessory
{
	NSString *title = [NSString stringWithFormat:@"%@ - PIN: %@", accessory.information.name ?: @"Light", accessory.passcode];
	NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:title action:nil keyEquivalent:title];
	menuItem.representedObject = accessory;
	
	return menuItem;
}

- (NSMenuItem *)menuItemForAccessory:(HKBAccessory *)accessory
{
	NSMenuItem *item = nil;
	for (NSMenuItem *menuItem in self.lightsMenu.itemArray) {
		HKBAccessory *menuAccessory = [menuItem representedObject];
		if (menuAccessory == accessory) {
			item = menuItem;
			break;
		}
	}
	
	return item;
}

- (void)startDiscovery
{
	for(HKBDiscoveryService *discoveryService in self.discoveryServices) {
		[discoveryService startDiscovery];
	}
}

- (void)stopDiscovery
{
	for(HKBDiscoveryService *discoveryService in self.discoveryServices) {
		[discoveryService stopDiscovery];
	}
}

#pragma mark - HKBDiscoveryServiceDelegate

- (void)discoveryService:(HKBDiscoveryService *)service didDiscoverAccessory:(HKBAccessory *)accessory
{
	if(![self.accessories containsObject:accessory]) {
		[accessory setupServices];
		
		[self.accessories addObject:accessory];
		[self.lightsMenu addItem:[self menuItemForAccessory:accessory]];
	}
}

- (void)discoveryService:(HKBDiscoveryService *)service didLostAccessory:(HKBAccessory *)accessory
{
	if([self.accessories containsObject:accessory]) {
		[self.accessories removeObject:accessory];
		[self.lightsMenu removeItem:[self menuItemForAccessory:accessory]];
	}
}

@end
