//
//  LayerManager.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/10/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "LayerManager.h"

#import "CoreDataReader.h"



@interface LayerManager ()

@property(strong,nonatomic) LYRClient* client;
@property(strong,nonatomic) LayerAPI* layerAPI;
@property(strong,nonatomic) LayerDataProcessor* dataProcessor;
@property(strong,nonatomic) LayerDataAssembler* dataAssembler;
@property(strong,nonatomic) CoreDataReader* dataReader;
@property(strong,nonatomic) CoreDataWriter* dataWriter;

@property(assign,nonatomic) BOOL authenticating;

@end



@implementation LayerManager


- (id)init {
    self = [super init];
    if (self) {
        NSUUID *appID = [[NSUUID alloc] initWithUUIDString:@"2ed63e76-2c84-11e4-a2c3-8edc000001f6"];
        _client = [LYRClient clientWithAppID:appID];
        _client.delegate = self;
        _layerAPI = [[LayerAPI alloc] init];
        _dataProcessor = [[LayerDataProcessor alloc] init];
        _dataAssembler = [[LayerDataAssembler alloc] init];
        _dataReader = [[CoreDataReader alloc] init];
        _dataWriter = [[CoreDataWriter alloc] init];
        _dataWriter.client = _client;
        
        [self connect];
    }
    return self;
}


#pragma mark - Public

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    _dataReader.managedObjectContext = managedObjectContext;
    _dataWriter.managedObjectContext = managedObjectContext;
}

- (void)connect {
    [_client connectWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"connected to layer");
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
                                NSLog(@"authenticated user %@ to layer", authenticatedUserID);
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

- (void)obtainIdentityTokenWithNonce:(NSString*)nonce completion:(void(^)(NSString* identitiyToken, NSError*error))block {
    [_layerAPI authenticateWithNonce:nonce block:block];
}


#pragma mark - Hydration Utils

// Hydrates Conversation objects' internal LYRMessages and LYRConversation
- (void)hydrateConversations:(NSArray*)conversations {
    if (conversations.count) {
        // Hydrate LYRConversations
        NSMapTable* identifierToObjectLookup = [NSMapTable weakToWeakObjectsMapTable];
        NSMutableSet* conversationIds = [NSMutableSet setWithCapacity:conversations.count];
        
        NSMutableArray* messages = [NSMutableArray arrayWithCapacity:conversations.count * 2];
        for (Conversation* c in conversations) {
            [conversationIds addObject:c.identifier];
            [identifierToObjectLookup setValue:c forKey:c.identifier];
            
            if (c.lastMessage) {
                [messages addObject:c.lastMessage];
            }
            if (c.messageTopic) {
                [messages addObject:c.messageTopic];
            }
        }
        
        NSSet* lyrConversations = [_client conversationsForIdentifiers:conversationIds.copy];
        
        for (LYRConversation* c in lyrConversations.allObjects) {
            Conversation* cRef = [identifierToObjectLookup objectForKey:c.identifier.absoluteString];
            cRef.lyrConversation = c;
        }
        
        // Hydrate LYRMessages for lastMessage and messageTopic
        [self hydrateMessages:messages.copy];
    }
}

// Hydrates Message objects' internal LYRMessages
- (void)hydrateMessages:(NSArray*)messages {
    NSMapTable* identifierToObjectLookup = [NSMapTable weakToWeakObjectsMapTable];
    NSMutableSet* messageIds = [NSMutableSet setWithCapacity:messages.count];
    
    for (Message* m in messages) {
        [messageIds addObject:m.identifier];
        [identifierToObjectLookup setValue:m forKey:m.identifier];
    }
    
    NSSet* lyrMesages = [_client messagesForIdentifiers:messageIds.copy];
    
    for (LYRMessage* m in lyrMesages.allObjects) {
        Message* mRef = [identifierToObjectLookup objectForKey:m.identifier.absoluteString];
        mRef.lyrMessage = m;
    }
}


#pragma mark - Read

- (void)getRecentConversationsOfKind:(ConversationKind)type completionBlock:(void(^)(NSArray* converations, NSError* error))block {
    NSArray* fetchedResults = [_dataReader getRecentConversationsOfKind:type];
    [self hydrateConversations:fetchedResults];
    if (block) block(fetchedResults, nil);
}

- (void)getConversation:(NSString*)convoIdentifier completionBlock:(void(^)(Conversation* converasation, NSError* error))block {
    Conversation* conversation = [_dataReader getConversation:convoIdentifier];
    if (conversation) {
        [self hydrateConversations:@[conversation]];
        if (block) block(conversation, nil);
    }
    if (block) block(nil, nil);
}

- (void)getRecentMessagesForConversation:(NSString*)convoIdentifier ofKind:(MessageKind)kind completionBlock:(void(^)(NSArray* messages, NSError* error))block {
    NSArray* fetchedResults = [_dataReader getRecentMessagesForConversation:convoIdentifier ofKind:kind];
    [self hydrateMessages:fetchedResults];
    if (block) block(fetchedResults, nil);
}

- (void)getRecentConversationsForUser:(NSString*)userIdentifier ofKind:(ConversationKind)kind completionBlock:(void(^)(NSArray* conversations, NSError* error))block {
    NSArray* fetchedResults = [_dataReader getRecentConversationsForUser:userIdentifier ofKind:kind];
    [self hydrateConversations:fetchedResults];
    if (block) block(fetchedResults, nil);
}

- (void)getRecentConversationsForUser:(NSString*)userIdentifier ofConversationKind:(ConversationKind)convoKind andMessageKind:(MessageKind)messageKind completionBlock:(void(^)(NSArray* conversations, NSError* error))block {
    NSArray* fetchedResults = [_dataReader getRecentConversationsForUser:userIdentifier ofConversationKind:convoKind andMessageKind:messageKind];
    [self hydrateConversations:fetchedResults];
    if (block) block(fetchedResults, nil);
}


#pragma mark - Write

- (void)sendPlainMessage:(NSString*)body inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block {
    
    LYRMessage* lyrMessage = [_dataAssembler createPlainMessage:body forConversation:conversation.lyrConversation];
    
    NSError* err = nil;
    if (![_client sendMessage:lyrMessage error:&err]) {
        if (block) block(nil, err);
        return;
    }
    
    [_dataWriter writeLYRMessage:lyrMessage toConversation:conversation];
    
    
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
