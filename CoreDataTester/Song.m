//
//  Song.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/16/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "Song.h"

@implementation Song


- (NSDictionary*)jsonRepresentation {
    NSDictionary* json = [MTLJSONAdapter JSONDictionaryFromModel:self];
    return json;
}

+ (id)songWithJsonRepresentation:(NSDictionary*)json {
    NSError* error = nil;
    Song* ob = [MTLJSONAdapter modelOfClass:Song.class fromJSONDictionary:json error:&error];
    if (error) NSLog(@"error deserializing model %@", error);
    return ob;
}

+ (NSString*)mimeType {
    return @"music/track";
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"songType": @"song_type",
             @"identifier": @"identifier",
             @"playURL": @"play_url",
             @"previewURL": @"preview_url",
             @"sharingURL": @"sharing_url",
             @"imageURL": @"image_url",
             @"imageWidth": @"image_width",
             @"imageHeight": @"image_height",
             @"name": @"name",
             @"artist": @"artist",
             @"album": @"album",
             };
}

+ (NSValueTransformer *)playURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)previewURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)sharingURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)songTypeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"spotify": @(SongTypeSpotify),
                                                                           }];
}

@end
