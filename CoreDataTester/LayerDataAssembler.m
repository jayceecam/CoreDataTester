//
//  LayerDataAssembler.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/15/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "LayerDataAssembler.h"

@implementation LayerDataAssembler

- (LYRMessage*)createPlainMessage:(NSString*)message forConversation:(LYRConversation*)conversation {
    LYRMessagePart* dataPart = [LYRMessagePart messagePartWithText:message];
    LYRMessage* msg = [LYRMessage messageWithConversation:conversation parts:@[dataPart]];
    return msg;
}

@end
