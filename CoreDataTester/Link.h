//
//  Link.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/16/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle/Mantle.h>

@interface Link : MTLModel <MTLJSONSerializing>

@property(strong,nonatomic) NSURL* url;

@property(strong,nonatomic) NSURL* thumbURL;
@property(strong,nonatomic) NSNumber* thumbWidth;
@property(strong,nonatomic) NSNumber* thumbHeight;

@property(strong,nonatomic) NSString* title;
@property(strong,nonatomic) NSString* desc;
@property(strong,nonatomic) NSString* source;

- (NSDictionary*)jsonRepresentation;

+ (id)linkWithJsonRepresentation:(NSDictionary*)json;

+ (NSString*)mimeType;

@end
