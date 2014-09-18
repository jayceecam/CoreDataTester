//
//  Like.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/18/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle/Mantle.h>

@interface Like : MTLModel <MTLJSONSerializing>

@property(strong,nonatomic) NSString* parentMessageIdentifier;


- (NSDictionary*)jsonRepresentation;

+ (id)likeWithJsonRepresentation:(NSDictionary*)json;

+ (NSString*)mimeType;


@end
