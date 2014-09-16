//
//  LayerDataAssembler.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/15/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "LayerDataAssembler.h"

@implementation LayerDataAssembler


- (Message*)assemblePlainMessage:(NSString*)body forConversation:(Conversation*)conversation {
    LYRMessagePart* dataPart = [LYRMessagePart messagePartWithText:body];
    LYRMessage* msg = [LYRMessage messageWithConversation:conversation.lyrConversation parts:@[dataPart]];
    
    Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    
    message.identifier = msg.identifier.absoluteString;
    message.creatorIdentifier = _client.authenticatedUserID;
    message.createdDate = [NSDate date];
    message.kind = @(MKindMessagePlain);
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
    message.kind = @(MKindContentLink);
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
    message.kind = @(MKindContentSong);
    message.conversation = conversation;
    
    return message;
}

- (Message*)assemblePictureMessage:(UIImage*)image forConversation:(Conversation*)conversation {
    return [self assemblePictureMessage:image encodingFunction:[self.class jpgEncodingFunction] forConversation:conversation];
}

- (Message*)assemblePictureMessage:(UIImage*)image encodingFunction:(NSData*(^)(UIImage* image, NSString** mime))encodingBlock forConversation:(Conversation*)conversation {
    NSData* jpgData = UIImageJPEGRepresentation(image, 0.8);
    
    NSString* pictureMime = nil;
    NSData* data = encodingBlock(image, &pictureMime);
    
    LYRMessagePart* dataPart = [LYRMessagePart messagePartWithMIMEType:@"image/jpeg" data:jpgData];
    
    LYRMessage* msg = [LYRMessage messageWithConversation:conversation.lyrConversation parts:@[dataPart]];
    
    Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    
    message.identifier = msg.identifier.absoluteString;
    message.creatorIdentifier = _client.authenticatedUserID;
    message.createdDate = [NSDate date];
    message.kind = @(MKindContentSong);
    message.conversation = conversation;
    
    return message;
}

+ (LayerDataAssemblerEncodingFunction)jpgEncodingFunction:(CGFloat)quality {
    return ^(UIImage* image, NSString** mime) {
        *mime = @"image/jpeg";
        NSData* data = UIImageJPEGRepresentation(image, quality);
        return data;
    };
}

+ (LayerDataAssemblerEncodingFunction)jpgEncodingFunction {
    return [self jpgEncodingFunction:0.8];
}

@end
