//
//  Whisper.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/24/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle/Mantle.h>


@interface Whisper : MTLModel <MTLJSONSerializing>


@property(strong,nonatomic) NSString* body;

@property(strong,nonatomic) NSSet* audience;


- (NSDictionary*)jsonRepresentation;

+ (id)whisperWithJsonRepresentation:(NSDictionary*)json;

+ (NSString*)mimeType;

@end
