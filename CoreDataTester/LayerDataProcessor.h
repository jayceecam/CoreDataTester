//
//  LayerProcessor.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/15/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Data.h"


@interface LayerDataProcessor : NSObject

- (Conversation*)processConversation:(LYRConversation*)conversation changeType:(LYRObjectChangeType)changeType;

- (Message*)processMessage:(LYRMessage*)message changeType:(LYRObjectChangeType)changeType;

@end
