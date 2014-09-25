//
//  DBTest.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/9/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "AppDelegate.h"

#import "Conversation.h"
#import "Message.h"
#import "ParticipantIdentifier.h"
#import "CoreDataStore.h"


@interface DBTest : XCTestCase

@property(strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong,nonatomic) CoreDataStore* dataAccessor;

@end



@implementation DBTest

- (void)setUp {
    [super setUp];
    
    // ensure DB is wiped
    
    NSURL *storeURL = ((AppDelegate*)[UIApplication sharedApplication].delegate).applicationDBURL;
    
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    
    [((AppDelegate*)[UIApplication sharedApplication].delegate) resetCoreData];
    
    _managedObjectContext = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    _dataAccessor = [[CoreDataStore alloc] init];
    _dataAccessor.managedObjectContext = _managedObjectContext;
}

- (void)tearDown {
    
    // wipe DB
    
    NSURL *storeURL = ((AppDelegate*)[UIApplication sharedApplication].delegate).applicationDBURL;
    
    NSError* err = nil;
    if (![[NSFileManager defaultManager] removeItemAtURL:storeURL error:&err]) {
        NSLog(@"Unresolved error %@, %@", err, [err userInfo]);
        XCTAssert(NO);
    }
    
    _managedObjectContext = nil;
    
    [((AppDelegate*)[UIApplication sharedApplication].delegate) resetCoreData];
    
    [super tearDown];
}

- (void)createConversation {
    
    Conversation* conversation = (Conversation*)[NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:self.managedObjectContext];
    conversation.identifier = [NSString stringWithFormat:@"cid_%i", 0];
    conversation.kind = @(ConversationKindChat);
    
    Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    message.identifier = [NSString stringWithFormat:@"mid_%i", 0];
    message.creatorIdentifier = [NSString stringWithFormat:@"uid_%i", 0];
    message.createdDate = [NSDate date];
    message.kind = @(MessageKindMessagePlain);
    message.conversation = conversation;
    
    ParticipantIdentifier* participant = (ParticipantIdentifier*)[NSEntityDescription insertNewObjectForEntityForName:@"ParticipantIdentifier" inManagedObjectContext:self.managedObjectContext];
    participant.identifier = [NSString stringWithFormat:@"pid_%i", 0];
    participant.conversation = conversation;
    
    participant = (ParticipantIdentifier*)[NSEntityDescription insertNewObjectForEntityForName:@"ParticipantIdentifier" inManagedObjectContext:self.managedObjectContext];
    participant.identifier = [NSString stringWithFormat:@"pid_%i", 1];
    participant.conversation = conversation;
    
    [self save];
}

- (void)createRecentConversationsTestData {
    Message* message = nil;
    ParticipantIdentifier* participant = nil;
    
    // Chat
    Conversation* chat = (Conversation*)[NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:self.managedObjectContext];
    chat.identifier = @"t1.c1";
    chat.kind = @(ConversationKindChat);
    
    message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    message.identifier = @"t1.m1";
    message.creatorIdentifier = @"t1.u1";
    message.createdDate = [NSDate dateWithTimeIntervalSince1970:500];
    message.kind = @(MessageKindMessagePlain);
    message.conversation = chat;
    
    participant = (ParticipantIdentifier*)[NSEntityDescription insertNewObjectForEntityForName:@"ParticipantIdentifier" inManagedObjectContext:self.managedObjectContext];
    participant.identifier = @"t1.p1";
    participant.conversation = chat;
    
    participant = (ParticipantIdentifier*)[NSEntityDescription insertNewObjectForEntityForName:@"ParticipantIdentifier" inManagedObjectContext:self.managedObjectContext];
    participant.identifier = @"t1.p2";
    participant.conversation = chat;
    
    chat.lastMessage = message;
    
    // Thread
    Conversation* thread = (Conversation*)[NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:self.managedObjectContext];
    thread.identifier = @"t1.c2";
    thread.kind = @(ConversationKindMoment);
    
    message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    message.identifier = @"t1.m2";
    message.creatorIdentifier = @"t1.u2";
    message.createdDate = [NSDate dateWithTimeIntervalSince1970:0];
    message.kind = @(MessageKindMessagePlain);
    message.conversation = thread;
    
    participant = (ParticipantIdentifier*)[NSEntityDescription insertNewObjectForEntityForName:@"ParticipantIdentifier" inManagedObjectContext:self.managedObjectContext];
    participant.identifier = @"t1.p2";
    participant.conversation = thread;
    
    participant = (ParticipantIdentifier*)[NSEntityDescription insertNewObjectForEntityForName:@"ParticipantIdentifier" inManagedObjectContext:self.managedObjectContext];
    participant.identifier = @"t1.p3";
    participant.conversation = thread;
    
    thread.lastMessage = message;
    
    [self save];
}

- (void)testRecentConversations {
    
    [self createRecentConversationsTestData];
    
    // Ensure correct objects
    
    NSArray* convos = [_dataAccessor getRecentConversationsOfKind:ConversationKindAll];
    
    XCTAssert(convos.count == 2);
    
    XCTAssert([[convos[0] identifier] isEqualToString:@"t1.c1"]);
    XCTAssert([[convos[0] kind] isEqual:@(ConversationKindChat)]);
    
    XCTAssert([[convos[0] messages] count] == 1);
    XCTAssert([[[[[convos[0] messages] allObjects] firstObject] identifier] isEqualToString:@"t1.m1"]);
    XCTAssert([[[[[convos[0] messages] allObjects] firstObject] creatorIdentifier] isEqualToString:@"t1.u1"]);
    XCTAssert([[[[[convos[0] messages] allObjects] firstObject] kind] isEqual:@(MessageKindMessagePlain)]);
    
    XCTAssert([[convos[1] identifier] isEqualToString:@"t1.c2"]);
    XCTAssert([[convos[1] kind] isEqual:@(ConversationKindMoment)]);
    
    XCTAssert([[convos[1] messages] count] == 1);
    XCTAssert([[[[[convos[1] messages] allObjects] firstObject] identifier] isEqualToString:@"t1.m2"]);
    XCTAssert([[[[[convos[1] messages] allObjects] firstObject] creatorIdentifier] isEqualToString:@"t1.u2"]);
    XCTAssert([[[[[convos[1] messages] allObjects] firstObject] kind] isEqual:@(MessageKindMessagePlain)]);
    
    NSArray* convosChat = [_dataAccessor getRecentConversationsOfKind:ConversationKindChat];
    
    XCTAssert(convosChat.count == 1);
    
    XCTAssert([[convosChat[0] identifier] isEqualToString:@"t1.c1"]);
    XCTAssert([[convosChat[0] kind] isEqual:@(ConversationKindChat)]);
    
    NSArray* convosThread = [_dataAccessor getRecentConversationsOfKind:ConversationKindMoment];
    
    XCTAssert(convosThread.count == 1);
    
    XCTAssert([[convosThread[0] identifier] isEqualToString:@"t1.c2"]);
    XCTAssert([[convosThread[0] kind] isEqual:@(ConversationKindMoment)]);
}

- (void)testRecentConversationsUpdates {
    
    [self createRecentConversationsTestData];
    
    NSArray* convos = [_dataAccessor getRecentConversationsOfKind:ConversationKindChat];
    
    XCTAssert(convos.count == 1);
    
    Conversation* c = convos[0];
    
    c.kind = @(ConversationKindMoment);
    
    [self save];
    
    convos = [_dataAccessor getRecentConversationsOfKind:ConversationKindChat];
    
    XCTAssert(convos.count == 0);
}

- (void)testRecentMessages {
    
    [self createRecentConversationsTestData];
    
    NSArray* messages = [_dataAccessor getRecentMessagesForConversation:@"t1.c1" ofKind:MessageKindAll];
    
    XCTAssert(messages.count == 1);
    
    Message* message = nil;
    
    message = messages[0];
    
    XCTAssert([message.conversation.identifier isEqualToString:@"t1.c1"]);
    XCTAssert([message.identifier isEqualToString:@"t1.m1"]);
    
    Conversation* convo = [_dataAccessor getConversation:@"t1.c1"];
    
    XCTAssert([convo.identifier isEqualToString:@"t1.c1"]);
    
    // create new
    
    message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    message.identifier = @"t1.m3";
    message.creatorIdentifier = @"t1.u2";
    message.createdDate = [NSDate dateWithTimeIntervalSince1970:1000];
    message.kind = @(MessageKindMessagePlain);
    message.conversation = convo;
    
    [self save];
    
    XCTAssert(messages.count == 1);
    
    messages = [_dataAccessor getRecentMessagesForConversation:@"t1.c1" ofKind:MessageKindAll];
    
    XCTAssert(messages.count == 2);
    
    // create new photo one
    
    message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    message.identifier = @"t1.m4";
    message.creatorIdentifier = @"t1.u2";
    message.createdDate = [NSDate dateWithTimeIntervalSince1970:1000];
    message.kind = @(MessageKindContentLink);
    message.conversation = convo;
    
    [self save];
    
    messages = [_dataAccessor getRecentMessagesForConversation:@"t1.c1" ofKind:MessageKindAll];
    
    XCTAssert(messages.count == 3);
    
    messages = [_dataAccessor getRecentMessagesForConversation:@"t1.c1" ofKind:MessageKindMessagePlain];
    
    XCTAssert(messages.count == 2);
}

- (void)testRecentConversationsByUser {
    
    [self createRecentConversationsTestData];
    
    NSArray* convos = [_dataAccessor getRecentConversationsForUser:@"t1.p1" ofKind:ConversationKindAll];
    
    XCTAssert(convos.count == 1);
    
    convos = [_dataAccessor getRecentConversationsForUser:@"t1.p2" ofKind:ConversationKindAll];
    
    XCTAssert(convos.count == 2);
}

- (void)testParentConversations {
    
    [self createRecentConversationsTestData];
    
    Conversation* childConvo = (Conversation*)[NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:self.managedObjectContext];
    childConvo.identifier = @"t1.c3";
    childConvo.kind = @(ConversationKindChat);
    
    Message* message = (Message*)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    message.identifier = @"t1.m3";
    message.creatorIdentifier = @"t1.u1";
    message.createdDate = [NSDate dateWithTimeIntervalSince1970:500];
    message.kind = @(MessageKindMessagePlain);
    message.conversation = childConvo;
    
    ParticipantIdentifier* participant = (ParticipantIdentifier*)[NSEntityDescription insertNewObjectForEntityForName:@"ParticipantIdentifier" inManagedObjectContext:self.managedObjectContext];
    participant.identifier = @"t1.p1";
    participant.conversation = childConvo;
    
    participant = (ParticipantIdentifier*)[NSEntityDescription insertNewObjectForEntityForName:@"ParticipantIdentifier" inManagedObjectContext:self.managedObjectContext];
    participant.identifier = @"t1.p2";
    participant.conversation = childConvo;
    
    childConvo.lastMessage = message;
    
    Conversation* parentConvo = [_dataAccessor getConversation:@"t1.c1"];
    
    XCTAssert(parentConvo != nil);
    
    childConvo.parentConversation = parentConvo;
    childConvo.messageTopic = parentConvo.lastMessage;
    
    [self save];
    
    parentConvo = [_dataAccessor getConversation:@"t1.c1"];
    
    XCTAssert(parentConvo.linkedConversations.count == 1);
    
    XCTAssert([[parentConvo.linkedConversations.allObjects[0] identifier] isEqualToString:[childConvo identifier]]);
    
    childConvo = [_dataAccessor getConversation:@"t1.c3"];
    
    XCTAssert([childConvo.parentConversation.identifier isEqualToString:@"t1.c1"]);
}


- (void)save {
    NSError* error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        XCTAssert(NO);
    }
}



//- (void)testDB {
//    [self createConversation];
//    
//    NSArray* convos = [_dataAccessor getRecentConversationsOfKind:CKindAll];
//    NSLog(@"convos %@", convos);
//    XCTAssert(convos.count > 0);
//}

@end
