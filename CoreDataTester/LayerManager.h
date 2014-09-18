//
//  LayerManager.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/10/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <LayerKit/LayerKit.h>
#import "LayerAPI.h"
#import "Data.h"
#import "CoreDataStore.h"
#import "CoreDataWriter.h"
#import "LayerDataProcessor.h"
#import "LayerDataAssembler.h"




@interface LayerManager : NSObject <LYRClientDelegate>


@property(strong,nonatomic,readonly) LYRClient* client;

@property(strong,nonatomic,readonly) LayerAPI* layerAPI;

@property(strong,nonatomic,readonly) LayerDataProcessor* dataProcessor;

@property(strong,nonatomic,readonly) LayerDataAssembler* dataAssembler;

@property(strong,nonatomic,readonly) CoreDataStore* dataStore;


@property(strong,nonatomic) NSManagedObjectContext* managedObjectContext;



#pragma mark - Public

- (void)connect;

- (void)disconnect;

- (void)authenticate;



#pragma mark - Read

- (void)getRecentConversationsOfKind:(ConversationKind)type completionBlock:(void(^)(NSArray* converations, NSError* error))block;

- (void)getConversation:(NSString*)convoIdentifier completionBlock:(void(^)(Conversation* converasation, NSError* error))block;


- (void)getRecentMessagesForConversation:(NSString*)convoIdentifier ofKind:(MessageKind)kind completionBlock:(void(^)(NSArray* messages, NSError* error))block;


- (void)getRecentConversationsForUser:(NSString*)userIdentifier ofKind:(ConversationKind)kind completionBlock:(void(^)(NSArray* conversations, NSError* error))block;

- (void)getRecentConversationsForUser:(NSString*)userIdentifier ofConversationKind:(ConversationKind)convoKind andMessageKind:(MessageKind)messageKind completionBlock:(void(^)(NSArray* conversations, NSError* error))block;



#pragma mark - Write

- (void)sendPlainMessage:(NSString*)message inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendLinkMessage:(Link*)link inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendSongMessage:(Song*)song inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendPictureMessage:(Picture*)picture inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendLike:(Like*)like inConverstaion:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendSavedConversation:(Conversation*)conversation completionBlock:(void(^)(BOOL success, NSError* error))block;


- (void)markConversationAsRead:(Conversation*)conversation completionBlock:(void(^)(BOOL success, NSError* error))block;

- (void)markMessagesAsRead:(NSArray*)messages completionBlock:(void(^)(BOOL success, NSError* error))block;

- (void)markConversationAsRemoved:(Conversation*)conversation completionBlock:(void(^)(BOOL success, NSError* error))block;



#pragma mark - Conversation Util

- (Conversation*)findOrCreateConversationForParticipants:(NSSet*)participants;

- (Conversation*)findOrCreateConversationWithParentConversation:(Conversation*)parentConversation andMessageTopic:(Message*)messageTopic;


@end



