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

- (Message*)assembleMessageFromWhisper:(Whisper*)whisper forConversation:(Conversation*)conversation;

- (Message*)assembleMessageFromLink:(Link*)link forConversation:(Conversation*)conversation;

- (Message*)assembleMessageFromSong:(Song*)song forConversation:(Conversation*)conversation;

- (Message*)assembleMessageFromPicture:(Picture*)picture forConversation:(Conversation*)conversation;

- (Message*)assembleMessageFromMeta:(Meta*)meta forConversation:(Conversation*)conversation;

- (Message*)assembleMessageFromLike:(Like*)meta forConversation:(Conversation*)conversation;


- (Message*)assembleMessageFromObject:(id)object forConversation:(Conversation*)conversation;



#pragma mark - Message Disassembly

+ (NSString*)disassemblePlainTextFromMessage:(Message*)message;

+ (Whisper*)disassembleWhisperFromMessage:(Message*)message;

+ (Link*)disassembleLinkFromMessage:(Message*)message;

+ (Song*)disassembleSongFromMessage:(Message*)message;

+ (Picture*)disassemblePictureFromMessage:(Message*)message;

+ (Meta*)disassembleMetaFromMessage:(Message*)message;

+ (Like*)disassembleLikeFromMessage:(Message*)message;


+ (id)disassembleObjectFromMessage:(Message*)message;


#pragma mark - Util

+ (MessageKind)messageKindFromMime:(NSString*)mimeType;


#pragma mark - Conversation Assembly

- (Conversation*)assembleChatWithParticipantIds:(NSSet*)participantIds andMeta:(Meta*)meta;

- (Conversation*)assembleMomentWithParentConversation:(Conversation*)parentConversation andParentMessage:(Message*)parentMessage andMeta:(Meta*)meta;

- (Conversation*)assembleSidebarWithParentConversation:(Conversation*)parentConversation audience:(NSSet*)audienceIds andMeta:(Meta*)meta;



@end
