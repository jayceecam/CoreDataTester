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
    MessageKindContentPicture = 2,
    MessageKindContentLink = 3,
    MessageKindContentSong = 4,
    
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

@property(strong,nonatomic) NSDate* createdDate;



@property(strong,nonatomic) Conversation* conversation;

@property(strong,nonatomic) Message* parentMessage;

@property(strong,nonatomic) NSSet* linkedMessages;



#pragma mark - Layer Message

@property(strong,nonatomic) LYRMessage* lyrMessage;



#pragma mark - Text

@property(strong,nonatomic,readonly) NSString* body;


#pragma mark - Photo

@property(strong,nonatomic,readonly) NSURL* photoUrl;


#pragma mark - Link

@property(strong,nonatomic,readonly) NSURL* linkUrl;


@end


@interface Message (CoreDataGeneratedAccessors)

- (void)addLinkedMessagesObject:(Message*)value;
- (void)removeLinkedMessagesObject:(Message*)value;
- (void)addLinkedMessages:(NSSet*)value;
- (void)removeLinkedMessages:(NSSet*)value;

@end

