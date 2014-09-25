//
//  DataAccessor.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/8/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#import "Conversation.h"
#import "Message.h"


@interface CoreDataStore : NSObject


@property(strong,nonatomic) NSManagedObjectContext* managedObjectContext;

@property(strong,nonatomic) NSMapTable* managedObjects;


#pragma mark - Read

- (Conversation*)getConversation:(NSString*)convoIdentifier;

- (Message*)getMessage:(NSString*)messageIdentifier;


- (NSArray*)getRecentConversationsOfKind:(ConversationKind)type;


- (NSArray*)getRecentMessagesForConversation:(NSString*)convoIdentifier ofKind:(MessageKind)kind;


- (NSArray*)getRecentConversationsForUser:(NSString*)userIdentifier ofKind:(ConversationKind)kind;

- (NSArray*)getRecentConversationsForUser:(NSString*)userIdentifier ofConversationKind:(ConversationKind)convoKind andMessageKind:(MessageKind)messageKind;


- (NSArray*)getRecentConversationsForUsers:(NSSet*)userIdentifiers ofConversationKind:(ConversationKind)convoKind andMessageKind:(MessageKind)messageKind;


+ (NSUInteger)messageFetchLimit;


#pragma mark - Util

- (NSArray*)getRecentUnreadMessagesForConversation:(NSString*)convoIdentifier ofKind:(MessageKind)kind;

- (Conversation*)getChatWithParticipants:(NSSet*)participantIds;

- (Conversation*)getMomentWithParentConversation:(NSString*)parentConversationIdentifier parentMessage:(NSString*)parentMessageIdentifier;

- (Conversation*)getSidebarWithParentConversation:(NSString*)parentConversationIdentifier audienceIds:(NSSet*)audienceIds;


// @deprecated

//- (Conversation*)getConversationWithParticipants:(NSSet*)participants ofKind:(ConversationKind)kind;
//
//- (Conversation*)getConversationWithParentConversation:(NSString*)parentConversationIdentifier parentMessage:(NSString*)parentMessageIdentifier ofKind:(ConversationKind)kind;

@end
