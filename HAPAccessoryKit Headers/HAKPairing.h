//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import <objc/NSObject.h>

@class HAKTransport, NSArray, NSHashTable, NSObject<OS_dispatch_queue>, NSString;

@interface HAKPairing : NSObject
{
    NSHashTable *_connections;
    BOOL _admin;
    HAKTransport *_transport;
    NSString *_identifier;
    NSObject<OS_dispatch_queue> *_workQueue;
}

@property(retain, nonatomic) NSObject<OS_dispatch_queue> *workQueue; // @synthesize workQueue=_workQueue;
@property(readonly, nonatomic, getter=isAdmin) BOOL admin; // @synthesize admin=_admin;
@property(copy, nonatomic) NSString *identifier; // @synthesize identifier=_identifier;
@property(nonatomic) __weak HAKTransport *transport; // @synthesize transport=_transport;
- (void).cxx_destruct;
- (id)keychainObject;
- (void)_addConnection:(id)arg1;
- (void)addConnection:(id)arg1;
@property(readonly, nonatomic) NSArray *connections;
- (id)description;
- (BOOL)isEqual:(id)arg1;
- (unsigned long long)hash;
- (id)initWithIdentifier:(id)arg1 admin:(BOOL)arg2;

@end

