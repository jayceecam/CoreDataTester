//
//  LayerDataAssembler.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/15/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <LayerKit/LayerKit.h>

#import "Data.h"




@interface LayerDataAssembler : NSObject

@property(strong,nonatomic) LYRClient* client;

@property(strong,nonatomic) NSManagedObjectContext* managedObjectContext;



#pragma mark - Message Assemply

- (Message*)assembleMessageFromPlainText:(NSString*)body forConversation:(Conversation*)conversation;

- (Message*)assembleMessageFromLink:(Link*)link forConversation:(Conversation*)conversation;

- (Message*)assembleMessageFromSong:(Song*)song forConversation:(Conversation*)conversation;

- (Message*)assembleMessageFromPicture:(Picture*)picture forConversation:(Conversation*)conversation;

- (Message*)assembleMessageFromMeta:(Meta*)meta forConversation:(Conversation*)conversation;

- (Message*)assembleMessageFromLike:(Like*)meta forConversation:(Conversation*)conversation;


- (Message*)assembleMessageFromObject:(id)object forConversation:(Conversation*)conversation;



#pragma mark - Message Disassembly

- (NSString*)disassemblePlainTextFromMessage:(Message*)message;

- (Link*)disassembleLinkFromMessage:(Message*)message;

- (Song*)disassembleSongFromMessage:(Message*)message;

- (Picture*)disassemblePictureFromMessage:(Message*)message;

- (Meta*)disassembleMetaFromMessage:(Message*)message;

- (Like*)disassembleLikeFromMessage:(Message*)message;


- (id)disassembleObjectFromMessage:(Message*)message;



#pragma mark - Conversation Assembly

- (Conversation*)assembleConversationWithParticipants:(NSSet*)participants andMeta:(Meta*)meta;

- (Conversation*)assembleConversationWithParentConversation:(Conversation*)parentConversation andMessageTopic:(Message*)messageTopic andMeta:(Meta*)meta;



@end
