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



typedef NS_ENUM(NSInteger, DataObjectChangeType) {
    DataObjectChangeTypeCreate,
    DataObjectChangeTypeUpdate,
    DataObjectChangeTypeDelete
};


/**
 @abstract A key into a change dictionary describing the change type. @see `DataObjectChangeType` for possible types.
 */
extern NSString *const DataObjectChangeTypeKey; // Expect values defined in the enum `DataObjectChangeType` as `NSNumber` integer values.

/**
 @abstract A key into a change dictionary for the object that was created, updated, or deleted.
 */
extern NSString *const DataObjectChangeObjectKey; // The `Conversation` or `Message` that changed.

// Only applicable to `DataObjectChangeTypeUpdate`
extern NSString *const DataObjectChangePropertyKey; // i.e. participants, metadata, userInfo, index
extern NSString *const DataObjectChangeOldValueKey; // The value before synchronization
extern NSString *const DataObjectChangeNewValueKey; // The value after synchronization



@interface LayerDataProcessor : NSObject


@property(strong,nonatomic) NSManagedObjectContext* managedObjectContext;

@property(strong,nonatomic) CoreDataStore* dataStore;

@property(strong,nonatomic) LYRClient* client;


- (Conversation*)processConversation:(LYRConversation*)conversation changeType:(LYRObjectChangeType)changeType;

- (Message*)processMessage:(LYRMessage*)message changeType:(LYRObjectChangeType)changeType;

@end
