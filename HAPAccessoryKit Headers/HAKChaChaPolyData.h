//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import <objc/NSObject.h>

@class NSData;

@interface HAKChaChaPolyData : NSObject
{
    NSData *_data;
}

@property(copy, nonatomic) NSData *data; // @synthesize data=_data;
@property(readonly, nonatomic) NSData *authTag;
@property(readonly, nonatomic) NSData *encryptedData;

- (id)initWithData:(id)arg1;

@end

