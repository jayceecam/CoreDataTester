//
//  LayerProcessor.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/15/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "LayerDataProcessor.h"

#import "LayerDataAssembler.h"
#import "LayerManager.h"



@implementation LayerDataProcessor

- (id)init {
    self = [super init];
    if (self) {
        _dataStore = [[CoreDataStore alloc] init];
    }
    return self;
}

- (Conversation*)processConversation:(LYRConversation*)lyrConversation changeType:(LYRObjectChangeType)changeType changes:(NSDictionary*)changes {
    NSLog(@"processing conversation %@ type %li", lyrConversation.identifier.absoluteString, changeType);
    Conversation* conversation = nil;
    NSMutableDictionary* notifInfo = @{}.mutableCopy;
    
    switch (changeType) {
        case LYRObjectChangeTypeCreate: {
            conversation = [_dataStore getConversation:lyrConversation.identifier.absoluteString];
            if (conversation) {
                conversation.removed = @(lyrConversation.isDeleted);
                conversation.lyrConversation = lyrConversation;
            }
            else {
                conversation = (Conversation*)[NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:self.managedObjectContext];
                conversation.identifier = lyrConversation.identifier.absoluteString;
                conversation.removed = @(lyrConversation.isDeleted);
                conversation.createdDate = [NSDate date];
                conversation.lyrConversation = lyrConversation;
                
                for (NSString* pid in lyrConversation.participants) {
                    ParticipantIdentifier* participantId = (ParticipantIdentifier*)[NSEntityDescription insertNewObjectForEntityForName:@"ParticipantIdentifier" inManagedObjectContext:self.managedObjectContext];
                    participantId.identifier = pid;
                    participantId.conversation = conversation;
                }
                
                // TODO: determine if messages (the meta and lastMessage particularly) are available here or if we need to wait for processMessage
                //       assuming for now these messages will be sync'd later after this is processed
            }
            notifInfo[ConversationObjectKey] = conversation;
            notifInfo[ChangedObjectKey] = conversation;
            notifInfo[ChangeTypeKey] = @(ChangeTypeCreate);
            break;
        }
        case LYRObjectChangeTypeUpdate: {
            NSString* changeKey = changes[LYRObjectChangePropertyKey];
            NSLog(@"LYRConversation property %@ changed from %@ to %@", changeKey, changes[LYRObjectChangeOldValueKey], changes[LYRObjectChangeNewValueKey]);
            
            if ([changeKey isEqualToString:@"identifier"]) {
                conversation = [_dataStore getConversation:[changes[LYRObjectChangeOldValueKey] absoluteString]];
            }
            else {
                conversation = [_dataStore getConversation:lyrConversation.identifier.absoluteString];
            }
            
            if (conversation) {
                if ([changeKey isEqualToString:@"identifier"]) {
                    conversation.identifier = lyrConversation.identifier.absoluteString;
                }
                if ([changeKey isEqualToString:@"participants"]) {
                    
                }
                if ([changeKey isEqualToString:@"createdAt"]) {
                    conversation.createdDate = lyrConversation.createdAt;
                }
                if ([changeKey isEqualToString:@"lastMessage"]) {
                    Message* lastMessage = [_dataStore getMessage:lyrConversation.lastMessage.identifier.absoluteString];
                    if (lastMessage) {
                        conversation.lastMessage = lastMessage;
                    }
                    else {
                        NSLog(@"Message cannot be found for lastMessage update");
                    }
                }
                if ([changeKey isEqualToString:@"isDeleted"]) {
                    conversation.removed = @(lyrConversation.isDeleted);
                }
                
                conversation.lyrConversation = lyrConversation;
                
                notifInfo[ConversationObjectKey] = conversation;
                notifInfo[ChangedObjectKey] = conversation;
                notifInfo[ChangeTypeKey] = @(ChangeTypeUpdate);
                notifInfo[ChangePropertyKey] = changeKey;
                notifInfo[ChangeOldValueKey] = changes[LYRObjectChangeOldValueKey];
                notifInfo[ChangeNewValueKey] = changes[LYRObjectChangeNewValueKey];
            }
            else {
                // this shouldn't really happen often because these changes should have been previously sync'd in a LYRObjectChangeTypeCreate callback
                // but could potentially happen due to race condition
                // another possiblity would be to always rely on Layer's client / DB for loading conversations / messages
                // or by adding a resync mechanism
                
                conversation = (Conversation*)[NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:self.managedObjectContext];
                conversation.identifier = lyrConversation.identifier.absoluteString;
                conversation.removed = @(lyrConversation.isDeleted);
                conversation.createdDate = [NSDate date];
                conversation.lyrConversation = lyrConversation;
                
                for (NSString* pid in lyrConversation.participants) {
                    ParticipantIdentifier* participantId = (ParticipantIdentifier*)[NSEntityDescription insertNewObjectForEntityForName:@"ParticipantIdentifier" inManagedObjectContext:self.managedObjectContext];
                    participantId.identifier = pid;
                    participantId.conversation = conversation;
                }
                
                notifInfo[ConversationObjectKey] = conversation;
                notifInfo[ChangedObjectKey] = conversation;
                notifInfo[ChangeTypeKey] = @(ChangeTypeCreate);
            }
            break;
        }
        case LYRObjectChangeTypeDelete: {
            conversation = [_dataStore getConversation:lyrConversation.identifier.absoluteString];
            if (conversation) {
                [self.managedObjectContext deleteObject:conversation];
            }
            
            notifInfo[ConversationObjectKey] = conversation;
            notifInfo[ChangedObjectKey] = conversation;
            notifInfo[ChangeTypeKey] = @(ChangeTypeCreate);
            break;
        }
    }
    
    NSError* error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        [self error:@"process conversation" error:error];
        return nil;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConversationDidChangeNotification object:conversation userInfo:notifInfo.copy];
    if (conversation.parentConversation) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ConversationDidChangeNotification object:conversation.parentConversation userInfo:notifInfo.copy];
    }
    
    return conversation;
}

- (Message*)processMessage:(LYRMessage*)lyrMessage changeType:(LYRObjectChangeType)changeType changes:(NSDictionary*)changes {
    NSLog(@"processing message %@ type %li", lyrMessage.identifier.absoluteString, changeType);
    Message* message = nil;
    NSMutableDictionary* notifInfo = @{}.mutableCopy;
    
    switch (changeType) {
        case LYRObjectChangeTypeCreate: {
            message = [_dataStore getMessage:lyrMessage.identifier.absoluteString];
            if (message) {
                message.removed = @(lyrMessage.isDeleted);
                message.lyrMessage = lyrMessage;
            }
            else {
                message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
                message.identifier = lyrMessage.identifier.absoluteString;
                message.removed = @(lyrMessage.isDeleted);
                message.lyrMessage = lyrMessage;
                message.creatorIdentifier = lyrMessage.sentByUserID;
                
                LYRMessagePart* part = lyrMessage.parts[0];
                MessageKind kind = [LayerDataAssembler messageKindFromMime:part.MIMEType];
                message.kind = @(kind);
                message.createdDate = lyrMessage.sentAt;
                message.conversation = [_dataStore getConversation:lyrMessage.conversation.identifier.absoluteString];
                
                [self postProcessMessage:message];
            }
            
            notifInfo[ConversationObjectKey] = message.conversation;
            notifInfo[ChangedObjectKey] = message;
            notifInfo[ChangeTypeKey] = @(ChangeTypeCreate);
            break;
        }
        case LYRObjectChangeTypeUpdate: {
            
            NSString* changeKey = changes[LYRObjectChangePropertyKey];
            NSLog(@"LYRMessage property %@ changed from %@ to %@", changeKey, changes[LYRObjectChangeOldValueKey], changes[LYRObjectChangeNewValueKey]);
            
            if ([changeKey isEqualToString:@"identifier"]) {
                message = [_dataStore getMessage:[changes[LYRObjectChangeOldValueKey] absoluteString]];
            }
            else {
                message = [_dataStore getMessage:lyrMessage.identifier.absoluteString];
            }
            
            if (message) {
                if ([changeKey isEqualToString:@"identifier"]) {
                    message.identifier = lyrMessage.identifier.absoluteString;
                }
                if ([changeKey isEqualToString:@"index"]) {
                    // ignore
                }
                if ([changeKey isEqualToString:@"conversation"]) {
                    // ignore
                }
                if ([changeKey isEqualToString:@"parts"]) {
                    // ignore
                }
                if ([changeKey isEqualToString:@"isSent"]) {
                    // ignore
                }
                if ([changeKey isEqualToString:@"isDeleted"]) {
                    message.removed = @(lyrMessage.isDeleted);
                }
                if ([changeKey isEqualToString:@"sentAt"]) {
                    message.createdDate = lyrMessage.sentAt;
                }
                if ([changeKey isEqualToString:@"receivedAt"]) {
                    // ignore
                }
                if ([changeKey isEqualToString:@"sentByUserID"]) {
                    // ignore
                }
                if ([changeKey isEqualToString:@"recipientStatusByUserID"]) {
                    // ignore
                }
                
                message.lyrMessage = lyrMessage;
                
                notifInfo[ConversationObjectKey] = message.conversation;
                notifInfo[ChangedObjectKey] = message;
                notifInfo[ChangeTypeKey] = @(ChangeTypeUpdate);
                notifInfo[ChangePropertyKey] = changeKey;
                notifInfo[ChangeOldValueKey] = changes[LYRObjectChangeOldValueKey];
                notifInfo[ChangeNewValueKey] = changes[LYRObjectChangeNewValueKey];
            }
            else {
                NSLog(@"unable to find existing Message for UPDATE");
                message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
                message.identifier = lyrMessage.identifier.absoluteString;
                message.removed = @(lyrMessage.isDeleted);
                message.lyrMessage = lyrMessage;
                message.creatorIdentifier = lyrMessage.sentByUserID;
                
                LYRMessagePart* part = lyrMessage.parts[0];
                MessageKind kind = [LayerDataAssembler messageKindFromMime:part.MIMEType];
                message.kind = @(kind);
                message.createdDate = lyrMessage.sentAt;
                message.conversation = [_dataStore getConversation:lyrMessage.conversation.identifier.absoluteString];
                
                notifInfo[ConversationObjectKey] = message.conversation;
                notifInfo[ChangedObjectKey] = message;
                notifInfo[ChangeTypeKey] = @(ChangeTypeCreate);
            }
            
            [self postProcessMessage:message];
            
            break;
        }
        case LYRObjectChangeTypeDelete: {
            message = [_dataStore getMessage:lyrMessage.identifier.absoluteString];
            if (message) {
                [self.managedObjectContext deleteObject:message];
            }
            
            notifInfo[ConversationObjectKey] = message.conversation;
            notifInfo[ChangedObjectKey] = message;
            notifInfo[ChangeTypeKey] = @(ChangeTypeDelete);
            break;
        }
    }
    
    NSError* error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        [self error:@"process message" error:error];
        return nil;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConversationDidChangeNotification object:message.conversation userInfo:notifInfo.copy];
    if (message.conversation.parentConversation) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ConversationDidChangeNotification object:message.conversation.parentConversation userInfo:notifInfo.copy];
    }
    
    return message;
}

- (void)postProcessMessage:(Message*)message {
    if (message.kind.integerValue == MessageKindMeta) {
        Meta* meta = [LayerDataAssembler disassembleMetaFromMessage:message];
        message.conversation.kind = meta.conversationKind;
        if (meta.parentConversationIdentifier && meta.parentMessageIdentifier) {
            message.conversation.parentConversation = [_dataStore getConversation:meta.parentConversationIdentifier];
            message.conversation.parentMessage = [_dataStore getMessage:meta.parentMessageIdentifier];
        }
        message.conversation.messageMeta = message;
    }
    else {
        if ([message.conversation.lastMessage.createdDate laterDate:message.createdDate] == message.createdDate) {
            message.conversation.lastMessage = message;
        }
    }
}

- (BOOL)error:(NSString*)errorReason error:(NSError*)error {
    if (error) {
        NSLog(@"Data Processor error during %@: %@, %@", errorReason, error, [error userInfo]);
        NSAssert(NO, @"%@: %@, %@", errorReason, error, [error userInfo]);
        return YES;
    }
    return NO;
}

@end
