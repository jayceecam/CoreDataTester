//
//  LayerDataAssembler.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/15/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "LayerDataAssembler.h"

@implementation LayerDataAssembler



#pragma mark - Assembly

- (Message*)assembleMessageFromPlainText:(NSString*)body forConversation:(Conversation*)conversation {
    LYRMessagePart* dataPart = [LYRMessagePart messagePartWithText:body];
    LYRMessage* msg = [LYRMessage messageWithConversation:conversation.lyrConversation parts:@[dataPart]];
    
    Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    
    message.identifier = msg.identifier.absoluteString;
    message.creatorIdentifier = _client.authenticatedUserID;
    message.createdDate = [NSDate date];
    message.kind = @(MessageKindMessagePlain);
    message.conversation = conversation;
    
    return message;
}

- (Message*)assembleMessageFromWhisper:(Whisper*)whisper forConversation:(Conversation*)conversation {
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:whisper.jsonRepresentation options:0 error:&error];
    
    if (error) {
        NSAssert(NO, @"assembleMsgMessage error %@", error);
        NSLog(@"assembleMsgMessage error %@", error);
        return nil;
    }
    
    LYRMessagePart* dataPart = [LYRMessagePart messagePartWithMIMEType:[Whisper mimeType] data:jsonData];
    LYRMessage* msg = [LYRMessage messageWithConversation:conversation.lyrConversation parts:@[dataPart]];
    
    Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    
    message.identifier = msg.identifier.absoluteString;
    message.creatorIdentifier = _client.authenticatedUserID;
    message.createdDate = [NSDate date];
    message.kind = @(MessageKindMessageWhisper);
    message.conversation = conversation;
    
    return message;
}

- (Message*)assembleMessageFromLink:(Link*)link forConversation:(Conversation*)conversation {
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:link.jsonRepresentation options:0 error:&error];
    
    if (error) {
        NSAssert(NO, @"assembleLinkMessage error %@", error);
        NSLog(@"assembleLinkMessage error %@", error);
        return nil;
    }
    
    LYRMessagePart* dataPart = [LYRMessagePart messagePartWithMIMEType:[Link mimeType] data:jsonData];
    LYRMessage* msg = [LYRMessage messageWithConversation:conversation.lyrConversation parts:@[dataPart]];
    
    Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    
    message.identifier = msg.identifier.absoluteString;
    message.creatorIdentifier = _client.authenticatedUserID;
    message.createdDate = [NSDate date];
    message.kind = @(MessageKindContentLink);
    message.conversation = conversation;
    
    return message;
}

- (Message*)assembleMessageFromSong:(Song*)song forConversation:(Conversation*)conversation {
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:song.jsonRepresentation options:0 error:&error];
    
    if (error) {
        NSAssert(NO, @"assembleSongMessage error %@", error);
        NSLog(@"assembleSongMessage error %@", error);
        return nil;
    }
    
    LYRMessagePart* dataPart = [LYRMessagePart messagePartWithMIMEType:[Song mimeType] data:jsonData];
    LYRMessage* msg = [LYRMessage messageWithConversation:conversation.lyrConversation parts:@[dataPart]];
    
    Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    
    message.identifier = msg.identifier.absoluteString;
    message.creatorIdentifier = _client.authenticatedUserID;
    message.createdDate = [NSDate date];
    message.kind = @(MessageKindContentSong);
    message.conversation = conversation;
    
    return message;
}


- (Message*)assembleMessageFromPicture:(Picture*)picture forConversation:(Conversation*)conversation {
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:picture.jsonRepresentation options:0 error:&error];
    
    if (error) {
        NSAssert(NO, @"assemblePictureMessage error %@", error);
        NSLog(@"assemblePictureMessage error %@", error);
        return nil;
    }
    
    LYRMessagePart* dataPart = [LYRMessagePart messagePartWithMIMEType:[Picture mimeType] data:jsonData];
    LYRMessage* msg = [LYRMessage messageWithConversation:conversation.lyrConversation parts:@[dataPart]];
    
    Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    
    message.identifier = msg.identifier.absoluteString;
    message.creatorIdentifier = _client.authenticatedUserID;
    message.createdDate = [NSDate date];
    message.kind = @(MessageKindContentPicture);
    message.conversation = conversation;
    
    return message;
}

- (Message*)assembleMessageFromMeta:(Meta*)meta forConversation:(Conversation*)conversation {
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:meta.jsonRepresentation options:0 error:&error];
    
    if (error) {
        NSAssert(NO, @"assembleMetaMessage error %@", error);
        NSLog(@"assembleMetaMessage error %@", error);
        return nil;
    }
    
    LYRMessagePart* dataPart = [LYRMessagePart messagePartWithMIMEType:[Meta mimeType] data:jsonData];
    LYRMessage* msg = [LYRMessage messageWithConversation:conversation.lyrConversation parts:@[dataPart]];
    
    Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    
    message.identifier = msg.identifier.absoluteString;
    message.creatorIdentifier = _client.authenticatedUserID;
    message.createdDate = [NSDate date];
    message.kind = @(MessageKindMeta);
    message.conversation = conversation;
    
    return message;
}

- (Message*)assembleMessageFromLike:(Like*)meta forConversation:(Conversation*)conversation {
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:meta.jsonRepresentation options:0 error:&error];
    
    if (error) {
        NSAssert(NO, @"assembleLikeMessage error %@", error);
        NSLog(@"assembleLikeMessage error %@", error);
        return nil;
    }
    
    LYRMessagePart* dataPart = [LYRMessagePart messagePartWithMIMEType:[Like mimeType] data:jsonData];
    LYRMessage* msg = [LYRMessage messageWithConversation:conversation.lyrConversation parts:@[dataPart]];
    
    Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    
    message.identifier = msg.identifier.absoluteString;
    message.creatorIdentifier = _client.authenticatedUserID;
    message.createdDate = [NSDate date];
    message.kind = @(MessageKindActivityLike);
    message.conversation = conversation;
    
    return message;
}

- (Message*)assembleMessageFromObject:(id)object forConversation:(Conversation*)conversation {
    if ([object isKindOfClass:[NSString class]]) {
        return [self assembleMessageFromPlainText:object forConversation:conversation];
    }
    if ([object isKindOfClass:[Whisper class]]) {
        return [self assembleMessageFromWhisper:object forConversation:conversation];
    }
    if ([object isKindOfClass:[Link class]]) {
        return [self assembleMessageFromLink:object forConversation:conversation];
    }
    if ([object isKindOfClass:[Song class]]) {
        return [self assembleMessageFromSong:object forConversation:conversation];
    }
    if ([object isKindOfClass:[Picture class]]) {
        return [self assembleMessageFromPicture:object forConversation:conversation];
    }
    if ([object isKindOfClass:[Meta class]]) {
        return [self assembleMessageFromMeta:object forConversation:conversation];
    }
    if ([object isKindOfClass:[Like class]]) {
        return [self assembleMessageFromLike:object forConversation:conversation];
    }
    NSAssert(NO, @"reached end of assempleObject function");
    return nil;
}


#pragma mark Disassembly

+ (NSString*)disassemblePlainTextFromMessage:(Message*)message {
    LYRMessagePart* part = message.lyrMessage.parts[0];
    return [[NSString alloc] initWithData:part.data encoding:NSUTF8StringEncoding];
}

+ (Whisper*)disassembleWhisperFromMessage:(Message*)message {
    LYRMessagePart* part = message.lyrMessage.parts[0];
    
    NSError* error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:part.data options:0 error:&error];
    
    if (error) {
        NSAssert(NO, @"disassembleWhisper error %@", error);
        NSLog(@"disassembleWhisper error %@", error);
        return nil;
    }
    
    return [Whisper whisperWithJsonRepresentation:json];
}

+ (Link*)disassembleLinkFromMessage:(Message*)message {
    LYRMessagePart* part = message.lyrMessage.parts[0];
    
    NSError* error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:part.data options:0 error:&error];
    
    if (error) {
        NSAssert(NO, @"disassembleLink error %@", error);
        NSLog(@"disassembleLink error %@", error);
        return nil;
    }
    
    return [Link linkWithJsonRepresentation:json];
}

+ (Song*)disassembleSongFromMessage:(Message*)message {
    LYRMessagePart* part = message.lyrMessage.parts[0];
    
    NSError* error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:part.data options:0 error:&error];
    
    if (error) {
        NSAssert(NO, @"disassembleSong error %@", error);
        NSLog(@"disassembleSong error %@", error);
        return nil;
    }
    
    return [Song songWithJsonRepresentation:json];
}

+ (Picture*)disassemblePictureFromMessage:(Message*)message {
    LYRMessagePart* part = message.lyrMessage.parts[0];
    
    NSError* error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:part.data options:0 error:&error];
    
    if (error) {
        NSAssert(NO, @"disassemblePicture error %@", error);
        NSLog(@"disassemblePicture error %@", error);
        return nil;
    }
    
    return [Picture pictureWithJsonRepresentation:json];
}

+ (Meta*)disassembleMetaFromMessage:(Message*)message {
    LYRMessagePart* part = message.lyrMessage.parts[0];
    
    NSError* error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:part.data options:0 error:&error];
    
    if (error) {
        NSAssert(NO, @"disassembleMeta error %@", error);
        NSLog(@"disassembleMeta error %@", error);
        return nil;
    }
    
    return [Meta metaWithJsonRepresentation:json];
}

+ (Like*)disassembleLikeFromMessage:(Message*)message {
    LYRMessagePart* part = message.lyrMessage.parts[0];
    
    NSError* error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:part.data options:0 error:&error];
    
    if (error) {
        NSAssert(NO, @"disassembleLike error %@", error);
        NSLog(@"disassembleLike error %@", error);
        return nil;
    }
    
    return [Like likeWithJsonRepresentation:json];
}


+ (id)disassembleObjectFromMessage:(Message*)message {
    switch (message.kind.integerValue) {
        case MessageKindMessagePlain:
            return [self disassemblePlainTextFromMessage:message];
        case MessageKindMessageWhisper:
            return [self disassembleWhisperFromMessage:message];
        case MessageKindContentLink:
            return [self disassembleLinkFromMessage:message];
        case MessageKindContentSong:
            return [self disassembleSongFromMessage:message];
        case MessageKindContentPicture:
            return [self disassemblePictureFromMessage:message];
        case MessageKindMeta:
            return [self disassembleMetaFromMessage:message];
        case MessageKindActivityLike:
            return [self disassembleLikeFromMessage:message];
            
        default:
            NSAssert(NO, @"reached end of disassempleObject function");
            return nil;
    }
}


#pragma mark - Util

+ (MessageKind)messageKindFromMime:(NSString*)mimeType {
    if ([mimeType isEqualToString:@"text/plain"])
        return MessageKindMessagePlain;
    if ([mimeType isEqualToString:[Whisper mimeType]])
        return MessageKindMessageWhisper;
    if ([mimeType isEqualToString:[Link mimeType]])
        return MessageKindContentLink;
    if ([mimeType isEqualToString:[Song mimeType]])
        return MessageKindContentSong;
    if ([mimeType isEqualToString:[Picture mimeType]])
        return MessageKindContentPicture;
    if ([mimeType isEqualToString:[Like mimeType]])
        return MessageKindActivityLike;
    if ([mimeType isEqualToString:[Meta mimeType]])
        return MessageKindMeta;
    
    NSAssert(NO, @"unable to detect messageKind from mime %@", mimeType);
    return 0;
}


#pragma mark - Conversation Assembly

- (Conversation*)_assembleConversationWithParticipantIds:(NSSet*)participantIds andMeta:(Meta*)meta {
    
    LYRConversation* lyrConversation = [LYRConversation conversationWithParticipants:participantIds];
    
    Conversation* conversation = (Conversation*)[NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:self.managedObjectContext];
    conversation.identifier = lyrConversation.identifier.absoluteString;
    conversation.kind = meta.conversationKind;
    conversation.removed = @NO;
    conversation.lyrConversation = lyrConversation;
    
    for (NSString* pid in participantIds) {
        ParticipantIdentifier* participantId = (ParticipantIdentifier*)[NSEntityDescription insertNewObjectForEntityForName:@"ParticipantIdentifier" inManagedObjectContext:self.managedObjectContext];
        participantId.identifier = pid;
        participantId.conversation = conversation;
    }
    
    conversation.messageMeta = [self assembleMessageFromMeta:meta forConversation:conversation];
    
    return conversation;
}

- (Conversation*)assembleChatWithParticipantIds:(NSSet*)participantIds andMeta:(Meta*)meta {
    
    NSAssert(meta.conversationKind.integerValue == ConversationKindChat, @"meta.conversationKind != ConversationKindChat");
    
    Conversation* conversation = [self _assembleConversationWithParticipantIds:participantIds andMeta:meta];
    
    return conversation;
}

- (Conversation*)assembleMomentWithParentConversation:(Conversation*)parentConversation andParentMessage:(Message*)parentMessage andMeta:(Meta*)meta {
    
    NSMutableSet* participantIds = [NSMutableSet setWithCapacity:parentConversation.participantIdentifiers.count];
    for (ParticipantIdentifier* pi in parentConversation.participantIdentifiers) {
        [participantIds addObject:pi.identifier];
    }
    
    NSAssert(meta.conversationKind.integerValue == ConversationKindMoment, @"meta.conversationKind != ConversationKindMoment");
    
    Conversation* conversation = [self _assembleConversationWithParticipantIds:participantIds andMeta:meta];
    
    conversation.parentConversation = parentConversation;
    conversation.parentMessage = parentMessage;
    conversation.lastMessage = parentMessage;
    
    return conversation;
}

- (Conversation*)assembleSidebarWithParentConversation:(Conversation*)parentConversation audience:(NSSet*)audienceIds andMeta:(Meta*)meta {
    
    NSAssert(meta.conversationKind.integerValue == ConversationKindSidebar, @"meta.conversationKind != ConversationKindSidebar");
    
    Conversation* conversation = [self _assembleConversationWithParticipantIds:audienceIds andMeta:meta];
    
    conversation.parentConversation = parentConversation;
    
    return conversation;
}


@end
