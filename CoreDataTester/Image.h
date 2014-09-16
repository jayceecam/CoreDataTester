//
//  Image.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/16/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle/Mantle.h>


@interface Image : MTLModel <MTLJSONSerializing>


@property(strong,nonatomic) NSString* imageMimeType;

@property(strong,nonatomic) NSNumber* width;

@property(strong,nonatomic) NSNumber* height;

@property(strong,nonatomic) NSData* data;


- (NSDictionary*)jsonRepresentation;

+ (id)songWithJsonRepresentation:(NSDictionary*)json;

+ (NSString*)mimeType;


@end
