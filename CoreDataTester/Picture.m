//
//  Image.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/16/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "Picture.h"

@implementation Picture

- (id)initWithImage:(UIImage*)image {
    return [self initWithImage:image encodingFuction:[Picture jpgEncodingFunction]];
}

- (id)initWithImage:(UIImage*)image encodingFuction:(NSData*(^)(UIImage* image, NSString** mime))encodingBlock {
    self = [super init];
    if (self) {
        NSString* pictureMime = nil;
        NSData* data = encodingBlock(image, &pictureMime);
    
        self.imageMimeType = pictureMime;
        self.width = @(image.size.width);
        self.height = @(image.size.height);
        self.data = data;
    }
    return self;
}

- (NSDictionary*)jsonRepresentation {
    NSDictionary* json = [MTLJSONAdapter JSONDictionaryFromModel:self];
    return json;
}

+ (id)pictureWithJsonRepresentation:(NSDictionary*)json {
    NSError* error = nil;
    Picture* ob = [MTLJSONAdapter modelOfClass:Picture.class fromJSONDictionary:json error:&error];
    if (error) NSLog(@"error deserializing model %@", error);
    return ob;
}

+ (NSString*)mimeType {
    return @"picture/plain";
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


+ (ImageEncodingFunction)jpgEncodingFunction:(CGFloat)quality {
    return ^(UIImage* image, NSString** mime) {
        *mime = @"image/jpeg";
        NSData* data = UIImageJPEGRepresentation(image, quality);
        return data;
    };
}

+ (ImageEncodingFunction)jpgEncodingFunction {
    return [self jpgEncodingFunction:0.8];
}

@end
