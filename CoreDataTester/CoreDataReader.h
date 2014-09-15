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


@interface CoreDataReader : NSObject


@property(strong,nonatomic) NSManagedObjectContext* managedObjectContext;


- (Conversation*)getConversation:(NSString*)convoIdentifier;

- (Message*)getMessage:(NSString*)messageIdentifier;


- (NSArray*)getRecentConversationsOfKind:(ConversationKind)type;


- (NSArray*)getRecentMessagesForConversation:(NSString*)convoIdentifier ofKind:(MessageKind)kind;


- (NSArray*)getRecentConversationsForUser:(NSString*)userIdentifier ofKind:(ConversationKind)kind;

- (NSArray*)getRecentConversationsForUser:(NSString*)userIdentifier ofConversationKind:(ConversationKind)convoKind andMessageKind:(MessageKind)messageKind;


+ (NSUInteger)messageFetchLimit;




@end
