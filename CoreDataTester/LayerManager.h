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
#import "LayerDataProcessor.h"
#import "LayerDataAssembler.h"


typedef NS_ENUM(NSInteger, ChangeType) {
    ChangeTypeCreate,
    ChangeTypeUpdate,
    ChangeTypeDelete
};


/**
 @abstract Posted when any objects for a conversation have changed due to synchronization activities.
 @discussion The Notification object will always refer to the conversation in which this change has occured. These notifications
 are posted for both the immediate conversation and then also for any parentConversation as well.
 */
extern NSString *const ConversationDidChangeNotification;

/**
 @abstract References the actual conversation object that has changed.
 @discussion This is important when the conversation receiving the notification is actually monitoring for changes to the parentConversation.
 */
extern NSString *const ConversationObjectKey;

/**
 @abstract A key into a change dictionary for the object that has been created, updated or deleted.
 */
extern NSString *const ChangedObjectKey;

/**
 @abstract A key into a change dictionary describing the change type. @see `ChangeType` for possible types.
 */
extern NSString *const ChangeTypeKey;

// Only applicable to `ChangeTypeUpdate`
extern NSString *const ChangePropertyKey;
extern NSString *const ChangeOldValueKey;
extern NSString *const ChangeNewValueKey;



@interface LayerManager : NSObject <LYRClientDelegate>


@property(strong,nonatomic,readonly) LYRClient* client;

@property(strong,nonatomic,readonly) LayerAPI* layerAPI;

@property(strong,nonatomic,readonly) LayerDataProcessor* dataProcessor;

@property(strong,nonatomic,readonly) LayerDataAssembler* dataAssembler;

@property(strong,nonatomic,readonly) CoreDataStore* dataStore;


@property(strong,nonatomic) NSManagedObjectContext* managedObjectContext;


- (id)initWithContext:(NSManagedObjectContext*)context;


#pragma mark - Public

- (void)connect;

- (void)disconnect;

- (void)authenticate;

- (void)resync;


#pragma mark - Read

- (void)getRecentConversationsOfKind:(ConversationKind)type completionBlock:(void(^)(NSArray* converations, NSError* error))block;

- (void)getConversation:(NSString*)convoIdentifier completionBlock:(void(^)(Conversation* converasation, NSError* error))block;


- (void)getRecentMessagesForConversation:(NSString*)convoIdentifier ofKind:(MessageKind)kind completionBlock:(void(^)(NSArray* messages, NSError* error))block;


- (void)getRecentConversationsForUser:(NSString*)userIdentifier ofKind:(ConversationKind)kind completionBlock:(void(^)(NSArray* conversations, NSError* error))block;

- (void)getRecentConversationsForUser:(NSString*)userIdentifier ofConversationKind:(ConversationKind)convoKind andMessageKind:(MessageKind)messageKind completionBlock:(void(^)(NSArray* conversations, NSError* error))block;



#pragma mark - Write

- (void)sendPlainMessage:(NSString*)message inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendWhisperMessage:(Whisper*)whisper inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendLinkMessage:(Link*)link inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendSongMessage:(Song*)song inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendPictureMessage:(Picture*)picture inConversation:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;

- (void)sendLike:(Like*)like inConverstaion:(Conversation*)conversation completionBlock:(void(^)(Message* message, NSError* error))block;



- (void)sendSavedConversation:(Conversation*)conversation completionBlock:(void(^)(BOOL success, NSError* error))block;

- (void)sendSavedConversation:(Conversation*)conversation withMessage:(NSString*)message completionBlock:(void(^)(BOOL success, NSError* error))block;



- (void)markConversationAsRead:(Conversation*)conversation completionBlock:(void(^)(BOOL success, NSError* error))block;

- (void)markMessagesAsRead:(NSArray*)messages completionBlock:(void(^)(BOOL success, NSError* error))block;

- (void)markConversationAsRemoved:(Conversation*)conversation completionBlock:(void(^)(BOOL success, NSError* error))block;



#pragma mark - Conversation Util

- (Conversation*)findOrCreateChatWithParticipantIds:(NSSet*)participantIds;

- (Conversation*)findOrCreateMomentWithParentConversation:(Conversation*)parentConversation andParentMessage:(Message*)parentMessage;

- (Conversation*)findorCreateSidebarWithParentConversation:(Conversation*)parentConversation andParticipants:(NSSet*)participantIds;


@end



