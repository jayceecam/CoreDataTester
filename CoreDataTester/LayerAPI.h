//
//  LayerAPI.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/14/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "BaseAPI.h"

@interface LayerAPI : BaseAPI

@property(strong,nonatomic) NSString* authUrl;

- (AFHTTPRequestOperation*)authenticateWithNonce:(NSString*)nonce block:(APIBlock)block;

@end
