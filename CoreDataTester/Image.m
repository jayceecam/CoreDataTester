//
//  Image.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/16/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "Image.h"

@implementation Image


- (NSDictionary*)jsonRepresentation {
    NSDictionary* json = [MTLJSONAdapter JSONDictionaryFromModel:self];
    return json;
}

+ (id)songWithJsonRepresentation:(NSDictionary*)json {
    NSError* error = nil;
    Image* ob = [MTLJSONAdapter modelOfClass:Image.class fromJSONDictionary:json error:&error];
    if (error) NSLog(@"error deserializing model %@", error);
    return ob;
}

+ (NSString*)mimeType {
    return @"picture/photo";
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"imageMimeType": @"image_mime_type",
             @"width": @"width",
             @"height": @"height",
             @"data": @"data",
             };
}

+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^ id (NSString* str) {
                return [str dataUsingEncoding:NSUTF8StringEncoding];
            }
            reverseBlock:^ id (NSData* data) {
                return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }];
}


@end
