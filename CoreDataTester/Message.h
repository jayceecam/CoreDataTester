//
//  Message.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/8/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "Data.h"
#import <LayerKit/LayerKit.h>


typedef NS_ENUM(NSUInteger, MessageKind) {
    MessageKindAll = 0,
    
    MessageKindMessagePlain = 1,
    MessageKindMessageWhisper = 2,
    MessageKindContentPicture = 3,
    MessageKindContentLink = 4,
    MessageKindContentSong = 5,
    
    MessageKindActivityLike = 1000,
    
    MessageKindMeta = 5000,
    // Note: update validation rules when adding new message kinds
};



@class Conversation;


@interface Message : NSManagedObject


@property(strong,nonatomic) NSString* identifier;

@property(strong,nonatomic) NSString* creatorIdentifier;

@property(strong,nonatomic) NSNumber* kind;

@property(strong,nonatomic) NSNumber* hidden;

@property(strong,nonatomic) NSNumber* removed;

@property(strong,nonatomic) NSNumber* read;

@property(strong,nonatomic) NSDate* createdDate;



@property(strong,nonatomic) Conversation* conversation;



#pragma mark - Layer Message

@property(strong,nonatomic) LYRMessage* lyrMessage;






@end


@interface Message (CoreDataGeneratedAccessors)

- (void)addLinkedMessagesObject:(Message*)value;
- (void)removeLinkedMessagesObject:(Message*)value;
- (void)addLinkedMessages:(NSSet*)value;
- (void)removeLinkedMessages:(NSSet*)value;

@end

