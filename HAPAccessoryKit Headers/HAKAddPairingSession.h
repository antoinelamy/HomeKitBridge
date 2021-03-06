//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import <HAPAccessoryKit/HAKPairingSession.h>

@class HAKTLV8Container;

@interface HAKAddPairingSession : HAKPairingSession
{
    unsigned char _state;
    id <HAKAddPairingSessionDelegate> _delegate;
    HAKTLV8Container *_stateData;
}

@property(retain, nonatomic) HAKTLV8Container *stateData; // @synthesize stateData=_stateData;
@property(nonatomic) unsigned char state; // @synthesize state=_state;
@property __weak id <HAKAddPairingSessionDelegate> delegate; // @synthesize delegate=_delegate;
- (void).cxx_destruct;
- (id)handlePairingSessionReadRequest;
- (long long)handlePairingSessionWriteRequest:(id)arg1;
- (void)_lockSession;
- (id)_tlv8ResponseWithError:(unsigned char)arg1;
- (id)init;

@end

