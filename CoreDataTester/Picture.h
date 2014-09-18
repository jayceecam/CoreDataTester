//
//  Image.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/16/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <Mantle/Mantle.h>


typedef NSData* (^ImageEncodingFunction)(UIImage* image, NSString** mime);



@interface Picture : MTLModel <MTLJSONSerializing>


@property(strong,nonatomic) NSString* imageMimeType;

@property(strong,nonatomic) NSNumber* width;

@property(strong,nonatomic) NSNumber* height;

@property(strong,nonatomic) NSData* data;


- (id)initWithImage:(UIImage*)image;

- (id)initWithImage:(UIImage*)image encodingFuction:(NSData*(^)(UIImage* image, NSString** mime))encodingFunction;


- (NSDictionary*)jsonRepresentation;

+ (id)pictureWithJsonRepresentation:(NSDictionary*)json;

+ (NSString*)mimeType;


+ (ImageEncodingFunction)jpgEncodingFunction:(CGFloat)quality;

+ (ImageEncodingFunction)jpgEncodingFunction;


@end
