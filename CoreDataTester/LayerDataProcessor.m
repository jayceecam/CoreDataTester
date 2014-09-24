//
//  LayerProcessor.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/15/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "LayerDataProcessor.h"


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

- (Conversation*)processConversation:(LYRConversation*)lyrConversation changeType:(LYRObjectChangeType)changeType {
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
            conversation = [_dataStore getConversation:lyrConversation.identifier.absoluteString];
            if (conversation) {
                conversation.removed = @(lyrConversation.isDeleted);
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
    
    return conversation;
}

- (Message*)processMessage:(LYRMessage*)lyrMessage changeType:(LYRObjectChangeType)changeType {
    switch (changeType) {
        case LYRObjectChangeTypeCreate: {
            // look for meta
            
        }
            break;
        case LYRObjectChangeTypeUpdate: {
            
        }
            break;
        case LYRObjectChangeTypeDelete: {
            
        }
            break;
    }
    return nil;
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
