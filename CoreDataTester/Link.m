//
//  Link.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/16/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "Link.h"



@implementation Link


- (NSDictionary*)jsonRepresentation {
    NSDictionary* json = [MTLJSONAdapter JSONDictionaryFromModel:self];
    return json;
}


+ (id)linkWithJsonRepresentation:(NSDictionary*)json {
    NSError* error = nil;
    Link* ob = [MTLJSONAdapter modelOfClass:Link.class fromJSONDictionary:json error:&error];
    if (error) NSLog(@"error deserializing model %@", error);
    return ob;
}

+ (NSString*)mimeType {
    return @"link/plain";
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"url": @"link_url",
             @"thumbURL": @"thumb_url",
             @"thumbWidth": @"thumb_width",
             @"thumbHeight": @"thumb_height",
             @"title": @"title",
             @"desc": @"description",
             @"source": @"source",
             };
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)thumbURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
