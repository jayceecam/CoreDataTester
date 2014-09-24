//
//  Conversation.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/8/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "Data.h"


typedef enum : NSUInteger {
    ConversationKindAll = 0,
    
    ConversationKindUndefined = 1,
    
    ConversationKindChat = 2,
    ConversationKindMoment = 3,
    ConversationKindSidebar = 4,
    
    // Note: update validation rules when adding new conversation kinds
} ConversationKind;



@class Message;
@class ParticipantIdentifier;


@interface Conversation : NSManagedObject


@property(strong,nonatomic) NSString* identifier;

@property(strong,nonatomic) NSNumber* kind;

@property(strong,nonatomic) NSNumber* removed;



@property(strong,nonatomic) Conversation* parentConversation;

@property(strong,nonatomic) NSSet* linkedConversations;



@property(strong,nonatomic) NSSet* messages;

@property(strong,nonatomic) NSSet* participantIdentifiers;


@property(strong,nonatomic) Message* messageTopic;

@property(strong,nonatomic) Message* messageMeta;


// This message may or may not be linked (i.e. it may belong to another conversation but be linked)
// TODO: need to verify that this message is not hidden

@property(strong,nonatomic) Message* lastMessage;

// TODO: make sure we track who added/created this conversation, especially if it's a child convo


#pragma mark - Layer Conversation

@property(strong,nonatomic) LYRConversation* lyrConversation;

@end



@interface Conversation (CoreDataGeneratedAccessors)

- (void)addLinkedConversationsObject:(Conversation*)value;
- (void)removeLinkedConversationsObject:(Conversation*)value;
- (void)addLinkedConversations:(NSSet*)value;
- (void)removeLinkedConversations:(NSSet*)value;

- (void)addMessagesObject:(Message*)value;
- (void)removeMessagesObject:(Message*)value;
- (void)addMessages:(NSSet*)value;
- (void)removeMessages:(NSSet*)value;

- (void)addParticipantIdentifiersObject:(ParticipantIdentifier*)value;
- (void)removeParticipantIdentifiersObject:(ParticipantIdentifier*)value;
- (void)addParticipantIdentifiers:(NSSet*)value;
- (void)removeParticipantIdentifiers:(NSSet*)value;

@end

