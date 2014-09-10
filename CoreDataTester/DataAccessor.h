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


@interface DataAccessor : NSObject


@property(strong,nonatomic) NSManagedObjectContext* managedObjectContext;


- (NSArray*)getRecentConversationsOfKind:(ConversationKind)type;

- (Conversation*)getConversation:(NSString*)convoIdentifier;


- (NSArray*)getRecentMessagesForConversation:(NSString*)convoIdentifier ofKind:(MessageKind)kind;


- (NSArray*)getRecentConversationsForUser:(NSString*)userIdentifier ofKind:(ConversationKind)kind;

- (NSArray*)getRecentConversationsForUser:(NSString*)userIdentifier ofConversationKind:(ConversationKind)convoKind andMessageKind:(MessageKind)messageKind;



+ (NSUInteger)messageFetchLimit;


@end
