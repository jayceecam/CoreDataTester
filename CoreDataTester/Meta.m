//
//  Meta.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/17/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "Meta.h"

@implementation Meta


- (NSDictionary*)jsonRepresentation {
    NSDictionary* json = [MTLJSONAdapter JSONDictionaryFromModel:self];
    return json;
}


+ (id)metaWithJsonRepresentation:(NSDictionary*)json {
    NSError* error = nil;
    Meta* ob = [MTLJSONAdapter modelOfClass:Meta.class fromJSONDictionary:json error:&error];
    if (error) NSLog(@"error deserializing model %@", error);
    return ob;
}

+ (NSString*)mimeType {
    return @"meta";
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"parentConversationIdentifier": @"parent_conversation_identifier",
             @"parentMessageIdentifier": @"parent_message_identifier",
             @"conversationKind": @"conversation_kind",
             @"info": @"info",
             };
}


@end
