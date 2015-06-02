//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import <HAPAccessoryKit/HAKPairingSession.h>

@class HAKTLV8Container, NSData, NSString;

@interface HAKPairSetupSession : HAKPairingSession
{
    struct srp_st *_session;
    NSData *_salt;
    NSData *_publicKey;
    NSData *_secretKey;
    unsigned char _state;
    NSData *_sessionKey;
    HAKTLV8Container *_stateData;
    NSString *_username;
    NSString *_password;
    unsigned long long _failedAttempts;
    id <HAKPairSetupSessionDelegate> _delegate;
}

@property __weak id <HAKPairSetupSessionDelegate> delegate; // @synthesize delegate=_delegate;
@property(readonly, nonatomic) unsigned long long failedAttempts; // @synthesize failedAttempts=_failedAttempts;
@property(readonly, nonatomic) HAKTLV8Container *stateData; // @synthesize stateData=_stateData;
@property(readonly, nonatomic) NSData *sessionKey; // @synthesize sessionKey=_sessionKey;
@property(retain, nonatomic) NSString *password; // @synthesize password=_password;
@property(retain, nonatomic) NSString *username; // @synthesize username=_username;
@property(readonly, nonatomic) struct srp_st *session; // @synthesize session=_session;
@property(readonly, nonatomic) unsigned char state; // @synthesize state=_state;
@property(readonly, nonatomic) NSData *secretKey; // @synthesize secretKey=_secretKey;
- (void).cxx_destruct;
- (id)handlePairingSessionReadRequest;
- (long long)handlePairingSessionWriteRequest:(id)arg1;
- (id)_tlv8ResponseWithError:(unsigned char)arg1;
- (void)_lock;
- (void)_resetState;
- (void)reset;
- (BOOL)isComplete;
- (BOOL)isLocked;
- (id)proofResponseWithClientProof:(id)arg1;
- (id)generateSecretKeyWithPublicKey:(id)arg1;
@property(readonly, nonatomic) NSData *publicKey; // @synthesize publicKey=_publicKey;
@property(readonly, nonatomic) NSData *salt; // @synthesize salt=_salt;
- (id)init;

@end

