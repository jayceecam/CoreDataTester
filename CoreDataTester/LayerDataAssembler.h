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


typedef NSData* (^LayerDataAssemblerEncodingFunction)(UIImage* image, NSString** mime);



@interface LayerDataAssembler : NSObject

@property(strong,nonatomic) LYRClient* client;

@property(strong,nonatomic) NSManagedObjectContext* managedObjectContext;





- (Message*)assemblePlainMessage:(NSString*)body forConversation:(Conversation*)conversation;

- (Message*)assembleLinkMessage:(Link*)link forConversation:(Conversation*)conversation;

- (Message*)assembleSongMessage:(Song*)song forConversation:(Conversation*)conversation;

- (Message*)assemblePictureMessage:(UIImage*)image forConversation:(Conversation*)conversation;

- (Message*)assemblePictureMessage:(UIImage*)image encodingFunction:(NSData*(^)(UIImage* image, NSString** mime))encodingBlock forConversation:(Conversation*)conversation;


+ (LayerDataAssemblerEncodingFunction)jpgEncodingFunction;


@end
