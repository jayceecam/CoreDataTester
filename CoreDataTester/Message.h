//
//  Message.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/8/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "Data.h"


typedef NS_ENUM(NSUInteger, MessageKind) {
    MKindAll = 0,
    MKindMessagePlain,
    MKindMessageWhisper,
    MKindContentPhoto,
    MKindContentVideo,
    MKindContentGIF,
    MKindContentLink,
    MKindActivityLike,
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




#pragma mark - Text

@property(strong,nonatomic,readonly) NSString* body;

@property(strong,nonatomic,readonly) NSArray* audience;


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

