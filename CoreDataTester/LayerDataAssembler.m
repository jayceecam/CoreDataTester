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

- (Message*)assemblePlainMessage:(NSString*)body forConversation:(Conversation*)conversation {
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

- (Message*)assembleLinkMessage:(Link*)link forConversation:(Conversation*)conversation {
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:link.jsonRepresentation options:0 error:&error];
    
    if (error) {
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

- (Message*)assembleSongMessage:(Song*)song forConversation:(Conversation*)conversation {
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:song.jsonRepresentation options:0 error:&error];
    
    if (error) {
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


- (Message*)assemblePictureMessage:(Picture*)picture forConversation:(Conversation*)conversation {
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:picture.jsonRepresentation options:0 error:&error];
    
    if (error) {
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

- (Message*)assembleMetaMessage:(Meta*)meta forConversation:(Conversation*)conversation {
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:meta.jsonRepresentation options:0 error:&error];
    
    if (error) {
        NSLog(@"assembleLinkMessage error %@", error);
        return nil;
    }
    
    LYRMessagePart* dataPart = [LYRMessagePart messagePartWithMIMEType:[Meta mimeType] data:jsonData];
    LYRMessage* msg = [LYRMessage messageWithConversation:conversation.lyrConversation parts:@[dataPart]];
    
    Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    
    message.identifier = msg.identifier.absoluteString;
    message.creatorIdentifier = _client.authenticatedUserID;
    message.createdDate = [NSDate date];
    message.kind = @(MessageKindContentSong);
    message.conversation = conversation;
    
    return message;
}


#pragma mark Disassembly

- (NSString*)disassemblePlainMessage:(Message*)message {
    LYRMessagePart* part = message.lyrMessage.parts[0];
    return [[NSString alloc] initWithData:part.data encoding:NSUTF8StringEncoding];
}

- (Link*)disassembleLinkMessage:(Message*)message {
    LYRMessagePart* part = message.lyrMessage.parts[0];
    
    NSError* error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:part.data options:0 error:&error];
    
    if (error) {
        NSLog(@"disassembleLink error %@", error);
        return nil;
    }
    
    return [Link linkWithJsonRepresentation:json];
}

- (Song*)disassembleSongMessage:(Message*)message {
    LYRMessagePart* part = message.lyrMessage.parts[0];
    
    NSError* error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:part.data options:0 error:&error];
    
    if (error) {
        NSLog(@"disassembleLink error %@", error);
        return nil;
    }
    
    return [Song songWithJsonRepresentation:json];
}

- (Picture*)disassemblePictureMessage:(Message*)message {
    LYRMessagePart* part = message.lyrMessage.parts[0];
    
    NSError* error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:part.data options:0 error:&error];
    
    if (error) {
        NSLog(@"disassembleLink error %@", error);
        return nil;
    }
    
    return [Picture pictureWithJsonRepresentation:json];
}

- (id)disassembleMessageObject:(Message*)message {
    switch (message.kind.integerValue) {
        case MessageKindMessagePlain:
            return [self disassemblePlainMessage:message];
        case MessageKindContentLink:
            return [self disassembleLinkMessage:message];
        case MessageKindContentSong:
            return [self disassembleSongMessage:message];
        case MessageKindContentPicture:
            return [self disassemblePictureMessage:message];
            
        default:
            return nil;
    }
}



@end