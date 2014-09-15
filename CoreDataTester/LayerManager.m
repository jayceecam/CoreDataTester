//
//  LayerManager.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/10/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "LayerManager.h"

#import "LayerDataReader.h"



@interface LayerManager ()

@property(strong,nonatomic) LYRClient* client;
@property(strong,nonatomic) LayerAPI* layerAPI;
@property(strong,nonatomic) LayerDataReader* model;

@property(assign,nonatomic) BOOL authenticating;

@end



@implementation LayerManager


- (id)init {
    self = [super init];
    if (self) {
        _layerAPI = [[LayerAPI alloc] init];
        _dataProcessor = [[LayerDataProcessor alloc] init];
        
        _model = [[LayerDataReader alloc] init];
        
        NSUUID *appID = [[NSUUID alloc] initWithUUIDString:@"2ed63e76-2c84-11e4-a2c3-8edc000001f6"];
        
        _client = [LYRClient clientWithAppID:appID];
        _client.delegate = self;
        
        [self connect];
    }
    return self;
}


#pragma mark - Public

- (void)connect {
    [_client connectWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            
        }
        if (error) {
            NSLog(@"error %@", error.localizedDescription);
        }
    }];
}

- (void)disconnect {
    [_client disconnect];
}

- (void)authenticate {
    if (_authenticating) return;
    _authenticating = YES;
    
    if (!_client.authenticatedUserID) {
        [_client requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
            if (nonce) {
                [self obtainIdentityTokenWithNonce:nonce completion:^(NSString *identitiyToken, NSError *error) {
                    if (identitiyToken) {
                        [_client authenticateWithIdentityToken:identitiyToken completion:^(NSString *authenticatedUserID, NSError *error) {
                            if (authenticatedUserID) {
                                
                            }
                            if (error) {
                                NSLog(@"error %@", error);
                            }
                            _authenticating = NO;
                        }];
                    }
                    if (error) {
                        NSLog(@"error %@", error);
                        _authenticating = NO;
                    }
                }];
            }
            if (error) {
                NSLog(@"error %@", error);
                _authenticating = NO;
            }
        }];
    }
    else {
        _authenticating = NO;
    }
}


#pragma mark - 

- (void)obtainIdentityTokenWithNonce:(NSString*)nonce completion:(void(^)(NSString* identitiyToken, NSError*error))block {
    [_layerAPI authenticateWithNonce:nonce block:block];
}

#pragma mark - Read

- (void)getRecentConversationsOfKind:(ConversationKind)type completionBlock:(void(^)(NSArray* converation))block {
    
}

- (void)getConversation:(NSString*)convoIdentifier completionBlock:(void(^)(Conversation* converasation))block {
    
}


- (void)getRecentMessagesForConversation:(NSString*)convoIdentifier ofKind:(MessageKind)kind completionBlock:(void(^)(NSArray* messages))block {
    
}


- (void)getRecentConversationsForUser:(NSString*)userIdentifier ofKind:(ConversationKind)kind completionBlock:(void(^)(NSArray* conversations))block {
    
}

- (void)getRecentConversationsForUser:(NSString*)userIdentifier ofConversationKind:(ConversationKind)convoKind andMessageKind:(MessageKind)messageKind completionBlock:(void(^)(NSArray* conversations))block {
    
}

- (void)markConversationAsRead:(Conversation*)conversation {
    
}

- (void)markMessagesAsRead:(NSArray*)messages {
    for (Message* message in messages) {
//        [_client markMessageAsRead:message.lyrMessage error:<#(NSError *__autoreleasing *)#>]
    }
    
}

- (void)markConversationAsHidden:(Conversation*)conversation {
    
}

- (void)markConversationAsFavorited:(Conversation*)conversation {
    
}


#pragma mark - LayerDelegate

- (void)layerClient:(LYRClient *)client didFinishSynchronizationWithChanges:(NSArray *)changes {
    NSLog(@"Layer Client did finish synchronization");
    
    for (NSDictionary *change in changes) {
        id changeObject = [change objectForKey:LYRObjectChangeObjectKey];
        if ([changeObject isKindOfClass:[LYRConversation class]]) {
            LYRConversation* conversation = changeObject;
            LYRObjectChangeType updateKey = (LYRObjectChangeType)[[change objectForKey:LYRObjectChangeTypeKey] integerValue];
            switch (updateKey) {
                case LYRObjectChangeTypeCreate:
                    //
                    break;
                case LYRObjectChangeTypeUpdate:
                    //
                    break;
                case LYRObjectChangeTypeDelete:
                    //
                    break;
            }
        }
        else {
            LYRMessage* message = changeObject;
            LYRObjectChangeType updateKey = (LYRObjectChangeType)[[change objectForKey:LYRObjectChangeTypeKey] integerValue];
            switch (updateKey) {
                case LYRObjectChangeTypeCreate:
                    //
                    break;
                case LYRObjectChangeTypeUpdate:
                    //
                    break;
                case LYRObjectChangeTypeDelete:
                    //
                    break;
            }
        }
    }
}

- (void)layerClient:(LYRClient *)client didFailSynchronizationWithError:(NSError *)error {
    NSLog(@"Layer Cliend did fail Synchronization with error:%@", error);
    
    
}

- (void)layerClient:(LYRClient *)client didReceiveAuthenticationChallengeWithNonce:(NSString *)nonce {
    NSLog(@"teset");
    
    
}

- (void)layerClient:(LYRClient *)client didAuthenticateAsUserID:(NSString *)userID {
    
}

- (void)layerClientDidDeauthenticate:(LYRClient *)client {
    
}



@end
