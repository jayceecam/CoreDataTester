//
//  EmbedlyAPI.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/16/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <embedly-ios/Embedly.h>



@class EmbedlyExtractionImage;
@class EmbedlyExtractionResult;



@interface EmbedlyAPI : NSObject

- (void)extractURL:(NSURL*)url completionBlock:(void(^)(EmbedlyExtractionResult* result, NSError* error))block;

@end




@interface EmbedlyExtractionImage : NSObject

@property(assign,nonatomic) CGFloat width;
@property(assign,nonatomic) CGFloat height;

@property(assign,nonatomic) NSUInteger size;

@property(strong,nonatomic) NSURL* url;

@end




@interface EmbedlyExtractionResult : NSObject

@property(strong,nonatomic) NSURL* url;
@property(strong,nonatomic) NSURL* originalURL;

@property(strong,nonatomic) NSString* title;
@property(strong,nonatomic) NSString* desc;

@property(strong,nonatomic) NSString* providerName;
@property(strong,nonatomic) NSURL* providerURL;
@property(strong,nonatomic) NSString* providerDisplay;

@property(strong,nonatomic) NSURL* faviconURL;

@property(strong,nonatomic) NSArray* images;

@end