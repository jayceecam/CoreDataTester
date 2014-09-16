//
//  EmbedlyAPI.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/16/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "EmbedlyAPI.h"


#define kEmbedlyKey @"ce0f4d12726347e299b75f2f3818ba8b"


@implementation EmbedlyExtractionImage
@end

@implementation EmbedlyExtractionResult
@end


@implementation EmbedlyAPI


- (void)extractURL:(NSURL*)url completionBlock:(void(^)(EmbedlyExtractionResult* result, NSError* error))block {
    CGFloat maxW = [[UIScreen mainScreen] bounds].size.width;
    NSDictionary* params = @{@"maxwidth": [NSString stringWithFormat:@"%i", maxW], @"chars": @"200"};
    [self callExtract:url.absoluteString params:params optimizeImages:0 completionBlock:^(NSDictionary* response, NSError *error) {
        if (response) {
            EmbedlyExtractionResult* result = [[EmbedlyExtractionResult alloc] init];
            if (response[@"original_url"]) {
                result.originalURL = [NSURL URLWithString:response[@"original_url"]];
            }
            if (response[@"url"]) {
                result.url = [NSURL URLWithString:response[@"url"]];
            }
            result.title = response[@"title"];
            result.desc = response[@"description"];
            result.providerName = response[@"provider_name"];
            result.providerDisplay = response[@"provider_display"];
            if (response[@"provider_url"]) {
                result.providerURL = [NSURL URLWithString:response[@"provider_url"]];
            }
            if (response[@"favicon_url"]) {
                result.faviconURL = [NSURL URLWithString:response[@"favicon_url"]];
            }
            
            // images
            NSMutableArray* images = [NSMutableArray arrayWithCapacity:[response[@"images"] count]];
            for (NSDictionary* image in response[@"images"]) {
                [images addObject:[self extractImageFromData:image]];
            }
            if (images.count) {
                result.images = images.copy;
            }
            
            if (block) block(result, nil);
        }
        else {
            if (block) block(nil, error);
        }
    }];
}

- (EmbedlyExtractionImage*)extractImageFromData:(NSDictionary*)data {
    EmbedlyExtractionImage* image = [[EmbedlyExtractionImage alloc] init];
    if (data[@"url"]) {
        image.url = [NSURL URLWithString:data[@"url"]];
    }
    image.width = [data[@"width"] floatValue];
    image.height = [data[@"height"] floatValue];
    image.size = [data[@"size"] unsignedIntegerValue];
    return image;
}


- (void)callExtract:(NSString *)url params:(NSDictionary *)params optimizeImages:(NSInteger)width completionBlock:(void(^)(id response, NSError* error))block {
    NSMutableDictionary *completeParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [completeParams setObject:kEmbedlyKey forKey:@"key"];
    [completeParams setObject:url forKey:@"url"];
    if (width > 0) {
        [completeParams setObject:[NSString stringWithFormat:@"%ld", (long)width] forKey:@"image_width"];
    }
    
    [self fetchEmbedlyApi:@"/1/extract" withParams:completeParams completionBlock:block];
}


- (void)callEmbedlyApi:(NSString *)endpoint withUrl:(NSString *)url params:(NSDictionary *)params completionBlock:(void(^)(id response, NSError* error))block {
    NSMutableDictionary *completeParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [completeParams setObject:kEmbedlyKey forKey:@"key"];
    [completeParams setObject:url forKey:@"url"];
    
    [self fetchEmbedlyApi:endpoint withParams:completeParams completionBlock:block];
}

- (void)callEmbedlyApi:(NSString *)endpoint withUrls:(NSArray *)urls params:(NSDictionary *)params completionBlock:(void(^)(id response, NSError* error))block {
    NSMutableDictionary *completeParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [completeParams setObject:kEmbedlyKey forKey:@"key"];
    // Using NSArray causes [] to be appended to param name. NSSet avoids this.
    [completeParams setObject:[NSSet setWithArray:urls] forKey:@"urls"];
    
    [self fetchEmbedlyApi:endpoint withParams:completeParams completionBlock:block];
}

- (NSString *)buildEmbedlyUrl:(NSString *)endpoint withParams:(NSDictionary *)params {
    NSString *embedlyUrl;
    if ([endpoint hasPrefix:@"/1/display"]) {
        embedlyUrl = [NSString stringWithFormat:@"http://i.embed.ly%@", endpoint];
    } else {
        embedlyUrl = [NSString stringWithFormat:@"http://api.embed.ly%@", endpoint];
    }
    
    NSString *displayQuery = @"?";
    NSString *param;
    for (id key in params) {
        NSString *paramValue = [params[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        if ([displayQuery length] == 1) {
            displayQuery = [NSString stringWithFormat:@"?%@=%@", key, paramValue];
        } else {
            param = [NSString stringWithFormat:@"&%@=%@", key, paramValue];
            displayQuery = [displayQuery stringByAppendingString:param];
        }
    }
    
    return [NSString stringWithFormat:@"%@%@", embedlyUrl, displayQuery];
}

- (void)fetchEmbedlyApi:(NSString *)endpoint withParams:(NSDictionary *)params completionBlock:(void(^)(id response, NSError* error))block {
    NSString *embedlyUrl = [self buildEmbedlyUrl:endpoint withParams:params];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = requestSerializer;
    [requestSerializer setValue:@"embedly-ios/1.0" forHTTPHeaderField:@"User-Agent"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:embedlyUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}


@end
