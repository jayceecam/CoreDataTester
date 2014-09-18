//
//  Meta.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/17/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle/Mantle.h>


@interface Meta : MTLModel <MTLJSONSerializing>

@property(strong,nonatomic) NSString* parentConversationIdentifier;

@property(strong,nonatomic) NSString* parentMessageIdentifier;

@property(strong,nonatomic) NSNumber* conversationKind;

@property(strong,nonatomic) NSDictionary* info;


- (NSDictionary*)jsonRepresentation;

+ (id)metaWithJsonRepresentation:(NSDictionary*)json;

+ (NSString*)mimeType;

@end
