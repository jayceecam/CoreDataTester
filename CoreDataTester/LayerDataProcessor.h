//
//  LayerProcessor.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/15/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Data.h"

#import "CoreDataStore.h"
#import <LayerKit/LayerKit.h>




@interface LayerDataProcessor : NSObject


@property(strong,nonatomic) NSManagedObjectContext* managedObjectContext;

@property(strong,nonatomic) CoreDataStore* dataStore;

@property(strong,nonatomic) LYRClient* client;


- (Conversation*)processConversation:(LYRConversation*)conversation changeType:(LYRObjectChangeType)changeType changes:(NSDictionary*)changes;

- (Message*)processMessage:(LYRMessage*)message changeType:(LYRObjectChangeType)changeType changes:(NSDictionary*)changes;


@end
