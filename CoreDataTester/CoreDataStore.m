//  DataAccessor.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/8/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "CoreDataStore.h"

#import "Conversation.h"
#import "Message.h"


@implementation CoreDataStore


#pragma mark - Reader

- (NSArray*)getRecentConversationsOfKind:(ConversationKind)kind {

    // returns array of Conversation objects of kind ConversationKindChat
    
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Conversation"];
    
    if (kind == CKindAll) {
        request.predicate = [NSPredicate predicateWithFormat:@"(kind != %i) and (removed = FALSE) and (parentConversation = NULL)", CKindUndefined];
    }
    else {
        request.predicate = [NSPredicate predicateWithFormat:@"(kind = %i) and (removed = FALSE) and (parentConversation = NULL)", kind];
    }
    
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"lastMessage.createdDate" ascending:NO]];
    
    NSError* error;
    NSArray* fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchResults;
}

- (Conversation*)getConversation:(NSString*)convoIdentifier {
    
    // returns conversation with id
    
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Conversation"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"identifier LIKE %@", convoIdentifier];
    
    NSError* error;
    NSArray* fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchResults.firstObject;
}

- (Message*)getMessage:(NSString*)messageIdentifier {
    
    // returns message with id
    
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Message"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"identifier LIKE %@", messageIdentifier];
    
    NSError* error;
    NSArray* fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchResults.firstObject;
}

- (NSArray*)getRecentMessagesForConversation:(NSString*)convoIdentifier ofKind:(MessageKind)kind {
    
    // returns array of Message objects, ordered by date, with some limit, across all relavant and linked Conversations
    
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Message"];
    
    request.fetchLimit = [self.class messageFetchLimit];
    
    if (kind == MKindAll) {
        request.predicate = [NSPredicate predicateWithFormat:@"(removed = FALSE) and (hidden = FALSE) and ((conversation.identifier LIKE %@) or (conversation.parentConversation.identifier LIKE %@))", convoIdentifier, convoIdentifier];
    }
    else {
        request.predicate = [NSPredicate predicateWithFormat:@"(removed = FALSE) and (hidden = FALSE) and (kind = %i) and ((conversation.identifier LIKE %@) or (conversation.parentConversation.identifier LIKE %@))", kind, convoIdentifier, convoIdentifier];
    }
    
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO]];
    
    NSError* error;
    NSArray* fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchResults;
}

- (NSArray*)getRecentConversationsForUser:(NSString*)userIdentifier ofKind:(ConversationKind)kind {
    
    // returns array of Message objects, ordered by date, with some limit, across all relavant and linked Conversations
    
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Conversation"];
    
    if (kind == CKindAll) {
        request.predicate = [NSPredicate predicateWithFormat:@"(removed = FALSE) and (kind != %i) and (parentConversation = NULL) and (ANY participantIdentifiers.identifier LIKE %@)", CKindUndefined, userIdentifier];
    }
    else {
        request.predicate = [NSPredicate predicateWithFormat:@"(removed = FALSE) and (kind = %i) and (parentConversation = NULL) and (ANY participantIdentifiers.identifier LIKE %@)", kind, userIdentifier];
    }
    
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"lastMessage.createdDate" ascending:NO]];
    
    NSError* error;
    NSArray* fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchResults;
}


- (NSArray*)getRecentConversationsForUser:(NSString*)userIdentifier ofConversationKind:(ConversationKind)convoKind andMessageKind:(MessageKind)messageKind {
    // returns array of Message objects, ordered by date, with some limit, across all relavant and linked Conversations
    
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Conversation"];
    
    if (convoKind == CKindAll) {
        if (messageKind == MKindAll) {
            request.predicate = [NSPredicate predicateWithFormat:@"(removed = FALSE) and (kind != %i) and (parentConversation = NULL) and (ANY participantIdentifiers.identifier LIKE %@)", CKindUndefined, userIdentifier];
        }
        else {
            request.predicate = [NSPredicate predicateWithFormat:@"(removed = FALSE) and (kind != %i) and (parentConversation = NULL) and (ANY participantIdentifiers.identifier LIKE %@) and (messageTopic.kind = %i)", CKindUndefined, userIdentifier, messageKind];
        }
    }
    else {
        if (messageKind == MKindAll) {
            request.predicate = [NSPredicate predicateWithFormat:@"(removed = FALSE) and (kind = %i) and (parentConversation = NULL) and (ANY participantIdentifiers.identifier LIKE %@)", convoKind, userIdentifier];
        }
        else {
            request.predicate = [NSPredicate predicateWithFormat:@"(removed = FALSE) and (kind = %i) and (parentConversation = NULL) and (ANY participantIdentifiers.identifier LIKE %@) and (messageTopic.kind = %i)", convoKind, userIdentifier, messageKind];
        }
    }
    
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"lastMessage.createdDate" ascending:NO]];
    
    NSError* error;
    NSArray* fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchResults;
}


+ (NSUInteger)messageFetchLimit {
    return 50;
}




@end
