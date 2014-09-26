//
//  LayerManager.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/10/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "LayerManager.h"

#import "CoreDataStore.h"


NSString *const ConversationDidChangeNotification = @"ConversationDidChangeNotification";

NSString *const ConversationObjectKey = @"ConversationObjectKey";

NSString *const ChangedObjectKey = @"ChangedObjectKey";

NSString *const ChangeTypeKey = @"ChangeTypeKey";

NSString *const ChangePropertyKey = @"ChangePropertyKey";
NSString *const ChangeOldValueKey = @"ChangeOldValueKey";
NSString *const ChangeNewValueKey = @"ChangeNewValueKey";


@interface LayerManager ()

@property(strong,nonatomic) LYRClient* client;
@property(strong,nonatomic) LayerAPI* layerAPI;
@property(strong,nonatomic) LayerDataProcessor* dataProcessor;
@property(strong,nonatomic) LayerDataAssembler* dataAssembler;
@property(strong,nonatomic) CoreDataStore* dataStore;

@property(assign,nonatomic) BOOL authenticating;

@end



@implementation LayerManager


- (id)initWithContext:(NSManagedObjectContext*)context {
    self = [super init];
    if (self) {
        NSUUID *appID = [[NSUUID alloc] initWithUUIDString:@"2ed63e76-2c84-11e4-a2c3-8edc000001f6"];
        _client = [LYRClient clientWithAppID:appID];
        _client.delegate = self;
        
        _layerAPI = [[LayerAPI alloc] init];
        _dataAssembler = [[LayerDataAssembler alloc] init];
        _dataStore = [[CoreDataStore alloc] init];
        _dataProcessor = [[LayerDataProcessor alloc] init];
        
        _dataProcessor.dataStore = _dataStore;
        _dataProcessor.client = _client;
        
        _dataAssembler.client = _client;
        
        self.managedObjectContext = context;
        
        [self connect];
    }
    return self;
}



#pragma mark - Public

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    _dataStore.managedObjectContext = managedObjectContext;
    _dataProcessor.managedObjectContext = managedObjectContext;
    _dataAssembler.managedObjectContext = managedObjectContext;
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

- (void)resync {
    
}

- (void)obtainIdentityTokenWithNonce:(NSString*)nonce completion:(void(^)(NSString* identitiyToken, NSError*error))block {
    [_layerAPI authenticateWithNonce:nonce block:block];
}


#pragma mark - Hydration Utils

// Hydrates Conversation objects' internal LYRMessages and LYRConversation
- (void)hydrateConversations:(NSArray*)conversations {
    @autoreleasepool {
        if (conversations.count) {
            // Hydrate LYRConversations
            NSMapTable* identifierToObjectLookup = [NSMapTable weakToWeakObjectsMapTable];
            NSMutableSet* conversationIds = [NSMutableSet setWithCapacity:conversations.count];
            
            NSMutableArray* messages = [NSMutableArray arrayWithCapacity:conversations.count * 2];
            for (Conversation* c in conversations) {
                [conversationIds addObject:[NSURL URLWithString:c.identifier]];
                [identifierToObjectLookup setObject:c forKey:c.identifier];
                
                if (c.messageMeta) {
                    [messages addObject:c.messageMeta];
                }
                if (c.lastMessage) {
                    [messages addObject:c.lastMessage];
                }
                if (c.parentMessage) {
                    [messages addObject:c.parentMessage];
                }
            }
            
            NSSet* lyrConversations = [_client conversationsForIdentifiers:conversationIds.copy];
            
            for (LYRConversation* c in lyrConversations.allObjects) {
                Conversation* cRef = [identifierToObjectLookup objectForKey:c.identifier.absoluteString];
                cRef.lyrConversation = c;
            }
            
            // Hydrate LYRMessages for lastMessage and parentMessage
            [self hydrateMessages:messages.copy];
        }
    }
}

// Hydrates Message objects' internal LYRMessages
- (void)hydrateMessages:(NSArray*)messages {
    @autoreleasepool {
        NSMapTable* identifierToObjectLookup = [NSMapTable weakToWeakObjectsMapTable];
        NSMutableSet* messageIds = [NSMutableSet setWithCapacity:messages.count];
        
        for (Message* m in messages) {
            [messageIds addObject:[NSURL URLWithString:m.identifier]];
            [identifierToObjectLookup setObject:m forKey:m.identifier];
        }
        
        NSSet* lyrMesages = [_client messagesForIdentifiers:messageIds.copy];
        
        for (LYRMessage* m in lyrMesages.allObjects) {
            Message* mRef = [identifierToObjectLookup objectForKey:m.identifier.absoluteString];
            mRef.lyrMessage = m;
        }
    }
}


#pragma mark - Read

- (void)getRecentConversationsOfKind:(ConversationKind)type completionBlock:(void(^)(NSArray* converations, NSError* error))block {
    NSArray* fetchedResults = [_dataStore getRecentConversationsOfKind:type];
    [self hydrateConversations:fetchedResults];
    if (block) block(fetchedResults, nil);
}

- (void)getMessage:(NSString*)messageIdentifier completionBlock:(void(^)(Message* message, NSError* error))block {
    Message* message = [_dataStore getMessage:messageIdentifier];
    if (message) {
        [self hydrateMessages:@[message]];
        if (block) block(message, nil);
    }
    else {
        // possibly check for existing LYRMessage
    }
    if (block) block(nil, nil);
}

- (void)getConversation:(NSString*)convoIdentifier completionBlock:(void(^)(Conversation* converasation, NSError* error))block {
    Conversation* conversation = [_dataStore getConversation:convoIdentifier];
    if (conversation) {
        [self hydrateConversations:@[conversation]];
        if (block) block(conversation, nil);
    }
    else {
        // possibly check for existing LYRConversation
    }
    if (block) block(nil, nil);
}

- (void)getRecentMessagesForConversation:(NSString*)convoIdentifier ofKind:(MessageKind)kind completionBlock:(void(^)(NSArray* messages, NSError* error))block {
    NSArray* fetchedResults = [_dataStore getRecentMessagesForConversation:convoIdentifier ofKind:kind];
    [self hydrateMessages:fetchedResults];
    if (block) block(fetchedResults, nil);
}

- (void)getRecentConversationsForUser:(NSString*)userIdentifier ofKind:(ConversationKind)kind completionBlock:(void(^)(NSArray* conversations, NSError* error))block {
    NSArray* fetchedResults = [_dataStore getRecentConversationsForUser:userIdentifier ofKind:kind];
    [self hydrateConversations:fetchedResults];
    if (block) block(fetchedResults, nil);
}

- (void)getRecentConversationsForUser:(NSString*)userIdentifier ofConversationKind:(ConversationKind)convoKind andMessageKind:(MessageKind)messageKind completionBlock:(void(^)(NSArray* conversations, NSError* error))block {
    NSArray* fetchedResults = [_dataStore getRecentConversationsForUser:userIdentifier ofConversationKind:convoKind andMessageKind:messageKind];
    [self hydrateConversations:fetchedResults];
    if (block) block(fetchedResults, nil);
}


#pragma mark - Write

- (BOOL)_sendMessage:(Message*)message forConversation:(Conversation*)conversation kind:(NSString*)kind completionBlock:(void(^)(Message* message, NSError* error))block {
    
    NSAssert(conversation.messageMeta, @"conversation %@ does not have a meta object", conversation);
    
    NSError* error = nil;
    
    if (!conversation.messageMeta.lyrMessage.identifier) {
        if (![_client sendMessage:conversation.messageMeta.lyrMessage error:&error]) {
            [self error:[NSString stringWithFormat:@"%@ conversation meta send", kind] error:error messageCompletionBlock:block];
            return NO;
        }
        
        conversation.messageMeta.identifier = conversation.messageMeta.lyrMessage.identifier.absoluteString;
        conversation.messageMeta.conversation.identifier = conversation.messageMeta.lyrMessage.conversation.identifier.absoluteString;
        
        conversation.lastMessage = conversation.messageMeta;
        conversation.parentConversation.lastMessage = conversation.messageMeta;
    }
    
    if (message) {
        if (![_client sendMessage:message.lyrMessage error:&error]) {
            [self error:[NSString stringWithFormat:@"%@ send", kind] error:error messageCompletionBlock:block];
            return NO;
        }
        
        conversation.lastMessage = message;
        conversation.parentConversation.lastMessage = message;
        
        message.identifier = message.lyrMessage.identifier.absoluteString;
        message.conversation.identifier = message.lyrMessage.conversation.identifier.absoluteString;
    }
    
    
    if (![self.managedObjectContext save:&error]) {
        [self error:[NSString stringWithFormat:@"%@ save", kind] error:error messageCompletionBlock:block];
        return NO;
    }
    
    if (block) block(message, nil);
    
    return YES;
}

- (void)sendPlainMessage:(NSString*)body inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block {
    
    Message* message = [_dataAssembler assembleMessageFromPlainText:body forConversation:conversation];
    
    [self _sendMessage:message forConversation:conversation kind:@"plain" completionBlock:block];
}

- (void)sendWhisperMessage:(Whisper*)whisper inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block {
    
    NSAssert(conversation.kind.integerValue == ConversationKindSidebar, @"cannot save a whisper into a conversation that is not of type ConversationKindSidebar");
    
    Message* message = [_dataAssembler assembleMessageFromWhisper:whisper forConversation:conversation];
    
    [self _sendMessage:message forConversation:conversation kind:@"whisper" completionBlock:block];
}

- (void)sendLinkMessage:(Link*)link inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block {
    
    Message* message = [_dataAssembler assembleMessageFromLink:link forConversation:conversation];
    
    [self _sendMessage:message forConversation:conversation kind:@"link" completionBlock:block];
}

- (void)sendSongMessage:(Song*)song inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block {
    
    Message* message = [_dataAssembler assembleMessageFromSong:song forConversation:conversation];
    
    [self _sendMessage:message forConversation:conversation kind:@"song" completionBlock:block];
}

- (void)sendPictureMessage:(Picture*)picture inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block {
    
    Message* message = [_dataAssembler assembleMessageFromPicture:picture forConversation:conversation];
    
    [self _sendMessage:message forConversation:conversation kind:@"picture" completionBlock:block];
}

- (void)sendLike:(Like*)like inConverstaion:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block {
    
    Message* message = [_dataAssembler assembleMessageFromLike:like forConversation:conversation];
    
    [self _sendMessage:message forConversation:conversation kind:@"like" completionBlock:block];
}

- (void)sendSavedConversation:(Conversation*)conversation completionBlock:(void(^)(BOOL success, NSError* error))block {
    
    NSAssert(conversation.kind.integerValue == ConversationKindMoment, @"cannot save a moment into a conversation that is not of type ConversationKindMoment");
    
    [self _sendMessage:nil forConversation:conversation kind:@"moment" completionBlock:^(Message *message, NSError *error) {
        if (block) block(!error, error);
    }];
}

- (void)sendSavedConversation:(Conversation*)conversation withMessage:(NSString*)body completionBlock:(void(^)(BOOL success, NSError* error))block {
    
    NSAssert(conversation.kind.integerValue == ConversationKindMoment, @"cannot save a moment into a conversation that is not of type ConversationKindMoment");
    
    [self _sendMessage:nil forConversation:conversation kind:@"moment with message" completionBlock:^(Message *message, NSError *error) {
        if (block) block(!error, error);
    }];
}

- (void)markConversationAsRead:(Conversation*)conversation completionBlock:(void(^)(BOOL success, NSError* error))block {
    NSArray* fetchedResults = [_dataStore getRecentUnreadMessagesForConversation:conversation.identifier ofKind:MessageKindAll];
    [self hydrateMessages:fetchedResults];
    [self markMessagesAsRead:fetchedResults completionBlock:block];
}

- (void)markMessagesAsRead:(NSArray*)messages completionBlock:(void(^)(BOOL success, NSError* error))block {
    
    if (messages.count) {
        
        NSError* error = nil;
        
        for (Message* message in messages) {
            message.read = @YES;
            
            if (![_client markMessageAsRead:message.lyrMessage error:&error]) {
                [self error:@"mark read" error:error successCompletionBlock:block];
                return;
            }
        }
        
        if (![self.managedObjectContext save:&error]) {
            [self error:@"mark read" error:error successCompletionBlock:block];
            return;
        }
    }
    
    if (block) block(YES, nil);
}

- (void)markConversationAsRemoved:(Conversation*)conversation completionBlock:(void(^)(BOOL success, NSError* error))block {
    conversation.removed = @YES;
    
    NSError* error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        [self error:@"mark read" error:error successCompletionBlock:block];
        return;
    }
}


#pragma mark - Conversation

- (Conversation*)findOrCreateChatWithParticipantIds:(NSSet*)participantIds {
    
    Conversation* conversation = [_dataStore getChatWithParticipants:participantIds];
    if (conversation) {
        [self hydrateConversations:@[conversation]];
        return conversation;
    }
    else {
        Meta* meta = [[Meta alloc] init];
        meta.conversationKind = @(ConversationKindChat);
        
        return [_dataAssembler assembleChatWithParticipantIds:participantIds andMeta:meta];
    }
}

- (Conversation*)findOrCreateMomentWithParentConversation:(Conversation*)parentConversation andParentMessage:(Message*)parentMessage {

    Conversation* conversation = [_dataStore getMomentWithParentConversation:parentConversation.identifier parentMessage:parentMessage.identifier];
    if (conversation) {
        [self hydrateConversations:@[conversation]];
        return conversation;
    }
    else {
        Meta* meta = [[Meta alloc] init];
        meta.conversationKind = @(ConversationKindMoment);
        meta.parentConversationIdentifier = parentConversation.identifier;
        meta.parentMessageIdentifier = parentMessage.identifier;
        
        return [_dataAssembler assembleMomentWithParentConversation:parentConversation andParentMessage:parentMessage andMeta:meta];
    }
}

- (Conversation*)findorCreateSidebarWithParentConversation:(Conversation*)parentConversation andParticipants:(NSSet*)participantIds {
    
    Conversation* conversation = [_dataStore getSidebarWithParentConversation:parentConversation.identifier audienceIds:participantIds];
    if (conversation) {
        [self hydrateConversations:@[conversation]];
        return conversation;
    }
    else {
        Meta* meta = [[Meta alloc] init];
        meta.conversationKind = @(ConversationKindSidebar);
        meta.parentConversationIdentifier = parentConversation.identifier;
        
        return [_dataAssembler assembleSidebarWithParentConversation:parentConversation audience:participantIds andMeta:meta];
    }
}

#pragma mark - Util

- (BOOL)error:(NSString*)errorReason error:(NSError*)error messageCompletionBlock:(void(^)(Message* message, NSError* error))block {
    if (error) {
        NSLog(@"Error during %@: %@, %@", errorReason, error, [error userInfo]);
        NSAssert(NO, @"%@: %@, %@", errorReason, error, [error userInfo]);
        if (block) block(nil, error);
        return YES;
    }
    return NO;
}

- (BOOL)error:(NSString*)errorReason error:(NSError*)error successCompletionBlock:(void(^)(BOOL success, NSError* error))block {
    if (error) {
        NSLog(@"Error during %@: %@, %@", errorReason, error, [error userInfo]);
        NSAssert(NO, @"%@: %@, %@", errorReason, error, [error userInfo]);
        if (block) block(NO, error);
        return YES;
    }
    return NO;
}


#pragma mark - LayerDelegate

- (void)layerClient:(LYRClient *)client didFinishSynchronizationWithChanges:(NSArray *)changes {
    NSLog(@"Layer Client did finish synchronization %@", changes);
    
    // TODO: always consider handling this sync on a new private queue
    // TODO: also ensure didReceiveLayerObjectsDidChangeNotification: is not also being called here
    
//    for (NSDictionary *change in changes) {
//        id changeObject = [change objectForKey:LYRObjectChangeObjectKey];
//        if ([changeObject isKindOfClass:[LYRConversation class]]) {
//            LYRConversation* conversation = changeObject;
//            LYRObjectChangeType changeType = (LYRObjectChangeType)[[change objectForKey:LYRObjectChangeTypeKey] integerValue];
//            [_dataProcessor processConversation:conversation changeType:changeType changes:change];
//        }
//        else {
//            LYRMessage* message = changeObject;
//            LYRObjectChangeType changeType = (LYRObjectChangeType)[[change objectForKey:LYRObjectChangeTypeKey] integerValue];
//            [_dataProcessor processMessage:message changeType:changeType changes:change];
//        }
//    }
}

- (void)layerClient:(LYRClient *)client didFailSynchronizationWithError:(NSError *)error {
    NSLog(@"Layer Cliend did fail Synchronization with error:%@", error);
}

- (void)layerClient:(LYRClient *)client didReceiveAuthenticationChallengeWithNonce:(NSString *)nonce {
    NSLog(@"layer client  did receive auth challenge");
    [self obtainIdentityTokenWithNonce:nonce completion:^(NSString *identitiyToken, NSError *error) {
        if (identitiyToken) {
            [_client authenticateWithIdentityToken:identitiyToken completion:^(NSString *authenticatedUserID, NSError *error) {
                if (authenticatedUserID) {
                    NSLog(@"authenticated user %@ to layer", authenticatedUserID);
                }
                if (error) {
                    NSLog(@"error %@", error);
                }
            }];
        }
        if (error) {
            NSLog(@"error %@", error);
        }
    }];
}

- (void)layerClient:(LYRClient *)client didAuthenticateAsUserID:(NSString *)userID {
    NSLog(@"layer client did authenticate as user id %@", userID);
}

- (void)layerClientDidDeauthenticate:(LYRClient *)client {
    NSLog(@"layer client  did deauthenticate");
}

@end
