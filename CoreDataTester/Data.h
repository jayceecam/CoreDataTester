//
//  Data.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/9/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <LayerKit/LayerKit.h>

#import "Conversation.h"
#import "Message.h"
#import "Whisper.h"
#import "ParticipantIdentifier.h"
#import "Link.h"
#import "Song.h"
#import "Picture.h"
#import "Meta.h"
#import "Like.h"


#define kErrorDomainData @"error.domain.data"



@interface Data : NSObject

+ (NSValueTransformer*)JSONSetTransformer;

@end
