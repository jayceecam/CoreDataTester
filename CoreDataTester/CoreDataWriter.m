////
////  CoreDataWriter.m
////  CoreDataTester
////
////  Created by Joe Cerra on 9/15/14.
////  Copyright (c) 2014 Joe Cerra. All rights reserved.
////
//
//#import "CoreDataWriter.h"
//
//@implementation CoreDataWriter
//
//- (Message*)writeLYRMessage:(LYRMessage*)lyrMessage toConversation:(Conversation*)conversation error:(NSError**)error {
//    Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
//    
//    message.identifier = lyrMessage.identifier.absoluteString;
//    message.creatorIdentifier = _client.authenticatedUserID;
//    message.createdDate = lyrMessage.sentAt;
//    message.kind = @(MKindMessagePlain);
//    message.conversation = conversation;
//    
//    NSError* err = [self save];
//    if (err && error) {
//        *error = err;
//        return nil;
//    }
//    
//    return message;
//}
//
//- (NSError*)save {
//    NSError* error = nil;
//    if (![self.managedObjectContext save:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        return error;
//    }
//    return nil;
//}
//
//@end
