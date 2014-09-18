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





- (Message*)assemblePlainMessage:(NSString*)body forConversation:(Conversation*)conversation;

- (Message*)assembleLinkMessage:(Link*)link forConversation:(Conversation*)conversation;

- (Message*)assembleSongMessage:(Song*)song forConversation:(Conversation*)conversation;

- (Message*)assemblePictureMessage:(Picture*)picture forConversation:(Conversation*)conversation;

- (Message*)assembleMetaMessage:(Meta*)meta forConversation:(Conversation*)conversation;



- (NSString*)disassemblePlainMessage:(Message*)message;

- (Link*)disassembleLinkMessage:(Message*)message;

- (Song*)disassembleSongMessage:(Message*)message;

- (Picture*)disassemblePictureMessage:(Message*)message;



@end
