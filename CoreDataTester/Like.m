//
//  Like.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/18/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "Like.h"

@implementation Like

- (NSDictionary*)jsonRepresentation {
    NSDictionary* json = [MTLJSONAdapter JSONDictionaryFromModel:self];
    return json;
}


+ (id)likeWithJsonRepresentation:(NSDictionary*)json {
    NSError* error = nil;
    Like* ob = [MTLJSONAdapter modelOfClass:Like.class fromJSONDictionary:json error:&error];
    if (error) NSLog(@"error deserializing model %@", error);
    return ob;
}

+ (NSString*)mimeType {
    return @"like/message";
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"parentMessageIdentifier": @"parent_message_identifier",
             };
}

@end
