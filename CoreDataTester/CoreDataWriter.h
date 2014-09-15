//
//  CoreDataWriter.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/15/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Data.h"
#import <LayerKit/LayerKit.h>

@interface CoreDataWriter : NSObject

@property(strong,nonatomic) LYRClient* client;

@property(strong,nonatomic) NSManagedObjectContext* managedObjectContext;

- (NSError*)writeLYRMessage:(LYRMessage*)lyrMessage toConversation:(Conversation*)conversation;

@end
