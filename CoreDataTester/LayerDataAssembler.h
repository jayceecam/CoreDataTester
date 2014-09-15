//
//  LayerDataAssembler.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/15/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <LayerKit/LayerKit.h>


@interface LayerDataAssembler : NSObject

- (LYRMessage*)createPlainMessage:(NSString*)message forConversation:(LYRConversation*)conversation;

@end
