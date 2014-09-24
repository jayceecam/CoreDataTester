//
//  Whisper.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/24/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "Whisper.h"

#import "Data.h"


@implementation Whisper

- (NSDictionary*)jsonRepresentation {
    NSDictionary* json = [MTLJSONAdapter JSONDictionaryFromModel:self];
    return json;
}


+ (id)whisperWithJsonRepresentation:(NSDictionary*)json {
    NSError* error = nil;
    Whisper* ob = [MTLJSONAdapter modelOfClass:Whisper.class fromJSONDictionary:json error:&error];
    if (error) NSLog(@"error deserializing model %@", error);
    return ob;
}

+ (NSString*)mimeType {
    return @"text/whisper";
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"body": @"body",
             @"audience": @"audience",
             };
}

+ (NSValueTransformer *)audienceJSONTransformer {
    return [Data JSONSetTransformer];
}

@end
