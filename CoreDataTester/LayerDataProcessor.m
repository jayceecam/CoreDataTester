//
//  LayerProcessor.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/15/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "LayerDataProcessor.h"

#import "LayerDataAssembler.h"


NSString *const DataObjectChangeTypeKey = @"DataObjectChangeTypeKey";

NSString *const DataObjectChangeObjectKey = @"DataObjectChangeObjectKey";

NSString *const DataObjectChangePropertyKey = @"DataObjectChangePropertyKey";
NSString *const DataObjectChangeOldValueKey = @"DataObjectChangeOldValueKey";
NSString *const DataObjectChangeNewValueKey = @"DataObjectChangeNewValueKey";


@implementation LayerDataProcessor

- (id)init {
    self = [super init];
    if (self) {
        _dataStore = [[CoreDataStore alloc] init];
    }
    return self;
}

- (Conversation*)processConversation:(LYRConversation*)lyrConversation changeType:(LYRObjectChangeType)changeType changes:(NSDictionary*)changes {
    Conversation* conversation = nil;
    
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
                conversation.lyrConversation = lyrConversation;
                
                for (NSString* pid in lyrConversation.participants) {
                    ParticipantIdentifier* participantId = (ParticipantIdentifier*)[NSEntityDescription insertNewObjectForEntityForName:@"ParticipantIdentifier" inManagedObjectContext:self.managedObjectContext];
                    participantId.identifier = pid;
                    participantId.conversation = conversation;
                }
                
                // TODO: determine if messages (the meta and lastMessage particularly) are available here or if we need to wait for processMessage
                //       assuming for now these messages will be sync'd later after this is processed
            }
            break;
        }
        case LYRObjectChangeTypeUpdate: {
            NSString* changeKey = changes[LYRObjectChangePropertyKey];
            NSLog(@"LYRConversation property %@ changed from %@ to %@", changeKey, changes[LYRObjectChangeOldValueKey], changes[LYRObjectChangeNewValueKey]);
            
            conversation = [_dataStore getConversation:lyrConversation.identifier.absoluteString];
            if (conversation) {
                if ([changeKey isEqualToString:@"identifier"]) {
                    
                }
                if ([changeKey isEqualToString:@"participants"]) {
                    
                }
                if ([changeKey isEqualToString:@"createdAt"]) {
                    
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
            }
            else {
                // this shouldn't really happen often because these changes should have been previously sync'd in a LYRObjectChangeTypeCreate callback
                // but could potentially happen due to race condition
                // another possiblity would be to always rely on Layer's client / DB for loading conversations / messages
                // or by adding a resync mechanism
                
                conversation = (Conversation*)[NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:self.managedObjectContext];
                conversation.identifier = lyrConversation.identifier.absoluteString;
                conversation.removed = @(lyrConversation.isDeleted);
                conversation.lyrConversation = lyrConversation;
                
                for (NSString* pid in lyrConversation.participants) {
                    ParticipantIdentifier* participantId = (ParticipantIdentifier*)[NSEntityDescription insertNewObjectForEntityForName:@"ParticipantIdentifier" inManagedObjectContext:self.managedObjectContext];
                    participantId.identifier = pid;
                    participantId.conversation = conversation;
                }
            }
            break;
        }
        case LYRObjectChangeTypeDelete: {
            conversation = [_dataStore getConversation:lyrConversation.identifier.absoluteString];
            if (conversation) {
                [self.managedObjectContext deleteObject:conversation];
            }
            break;
        }
    }
    
    NSError* error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        [self error:@"process conversation" error:error];
        return nil;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:<#(NSString *)#> object:<#(id)#> userInfo:<#(NSDictionary *)#>]
    
    return conversation;
}

- (Message*)processMessage:(LYRMessage*)lyrMessage changeType:(LYRObjectChangeType)changeType changes:(NSDictionary*)changes {
    Message* message = nil;
    
    switch (changeType) {
        case LYRObjectChangeTypeCreate: {
            message = [_dataStore getMessage:lyrMessage.identifier.absoluteString];
            if (message) {
                message.removed = @(lyrMessage.isDeleted);
                message.lyrMessage = lyrMessage;
            }
            else {
                Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
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
            break;
        }
        case LYRObjectChangeTypeUpdate: {
            
            NSString* changeKey = changes[LYRObjectChangePropertyKey];
            NSLog(@"LYRMessage property %@ changed from %@ to %@", changeKey, changes[LYRObjectChangeOldValueKey], changes[LYRObjectChangeNewValueKey]);
            
            message = [_dataStore getMessage:lyrMessage.identifier.absoluteString];
            
            if (message) {
                if ([changeKey isEqualToString:@"identifier"]) {
                    
                }
                if ([changeKey isEqualToString:@"index"]) {
                    
                }
                if ([changeKey isEqualToString:@"conversation"]) {
                    
                }
                if ([changeKey isEqualToString:@"parts"]) {
                    
                }
                if ([changeKey isEqualToString:@"isSent"]) {
                    
                }
                if ([changeKey isEqualToString:@"isDeleted"]) {
                    message.removed = @(lyrMessage.isDeleted);
                }
                if ([changeKey isEqualToString:@"sentAt"]) {
                    
                }
                if ([changeKey isEqualToString:@"receivedAt"]) {
                    
                }
                if ([changeKey isEqualToString:@"sentByUserID"]) {
                    
                }
                if ([changeKey isEqualToString:@"recipientStatusByUserID"]) {
                    
                }
                
                message.lyrMessage = lyrMessage;
            }
            else {
                NSLog(@"unable to find existing Message for UPDATE");
                Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
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
            
            [self postProcessMessage:message];
            
            break;
        }
        case LYRObjectChangeTypeDelete: {
            message = [_dataStore getMessage:lyrMessage.identifier.absoluteString];
            if (message) {
                [self.managedObjectContext deleteObject:message];
            }
            break;
        }
    }
    
    NSError* error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        [self error:@"process message" error:error];
        return nil;
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
