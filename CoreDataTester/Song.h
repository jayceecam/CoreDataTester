//
//  Song.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/16/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Mantle/Mantle.h>


typedef enum : NSUInteger {
    SongTypeSpotify,
} SongType;

@interface Song : MTLModel <MTLJSONSerializing>

@property(assign,nonatomic) SongType songType;

@property(strong,nonatomic) NSString* identifier;

@property(strong,nonatomic) NSURL* playURL;

@property(strong,nonatomic) NSURL* previewURL;

@property(strong,nonatomic) NSURL* sharingURL;

@property(strong,nonatomic) NSURL* imageURL;

@property(strong,nonatomic) NSNumber* imageWidth;

@property(strong,nonatomic) NSNumber* imageHeight;

@property(strong,nonatomic) NSString* name;

@property(strong,nonatomic) NSString* artist;

@property(strong,nonatomic) NSString* album;


- (NSDictionary*)jsonRepresentation;

+ (id)songWithJsonRepresentation:(NSDictionary*)json;

+ (NSString*)mimeType;


@end
