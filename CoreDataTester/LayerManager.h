//
//  LayerManager.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/10/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <LayerKit/LayerKit.h>
#import "LayerDataReader.h"
#import "Data.h"
#import "LayerAPI.h"
#import "LayerDataProcessor.h"


@interface LayerManager : NSObject <LYRClientDelegate>


@property(strong,nonatomic,readonly) LYRClient* client;

@property(strong,nonatomic,readonly) LayerAPI* layerAPI;

@property(strong,nonatomic,readonly) LayerDataProcessor* dataProcessor;

@property(strong,nonatomic,readonly) LayerDataReader* dataReader;


- (void)connect;

- (void)disconnect;

- (void)authenticate;


#pragma mark - Read

- (void)getRecentConversationsOfKind:(ConversationKind)type completionBlock:(void(^)(NSArray* converation, NSError* error))block;

- (void)getConversation:(NSString*)convoIdentifier completionBlock:(void(^)(Conversation* converasation, NSError* error))block;


- (void)getRecentMessagesForConversation:(NSString*)convoIdentifier ofKind:(MessageKind)kind completionBlock:(void(^)(NSArray* messages, NSError* error))block;


- (void)getRecentConversationsForUser:(NSString*)userIdentifier ofKind:(ConversationKind)kind completionBlock:(void(^)(NSArray* conversations, NSError* error))block;

- (void)getRecentConversationsForUser:(NSString*)userIdentifier ofConversationKind:(ConversationKind)convoKind andMessageKind:(MessageKind)messageKind completionBlock:(void(^)(NSArray* conversations, NSError* error))block;


#pragma mark - Write

- (void)sendTextMessage:(NSString*)message inConversation:(NSArray*)participantIds completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendLinkTextMessage:(NSString*)message inConversation:(NSArray*)participantIds completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendSongMessage:(NSString*)message inConversation:(NSArray*)participantIds completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendPictureMessage:(UIImage*)picture inConversation:(NSArray*)participantIds completionBlock:(void(^)(Message* message, NSError* error))block;


- (void)sendTextMessage:(NSString*)message inNewConversationWithParticipants:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendLinkTextMessage:(NSString*)message inNewConversationWithParticipants:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendSongMessage:(NSString*)message inNewConversationWithParticipants:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendPictureMessage:(NSString*)message inNewConversationWithParticipants:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;


- (void)markConversationAsRead:(Conversation*)conversation completionBlock:(void(^)(BOOL success, NSError* error))block;

- (void)markMessagesAsRead:(NSArray*)messages completionBlock:(void(^)(BOOL success, NSError* error))block;

- (void)markConversationAsHidden:(Conversation*)conversation completionBlock:(void(^)(BOOL success, NSError* error))block;

- (void)markConversationAsFavorited:(Conversation*)conversation completionBlock:(void(^)(BOOL success, NSError* error))block;


#pragma mark - Conversation

- (Conversation*)createConversation;

- (void)saveMessageToStory:(Message*)message completionBlock:(void(^)(BOOL success, NSError* error))block;

- (void)likeMessage:(Message*)message completionBlock:(void(^)(BOOL success, NSError* error))block;


@end

