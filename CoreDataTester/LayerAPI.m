//
//  LayerAPI.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/14/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "LayerAPI.h"


@implementation LayerAPI

- (AFHTTPRequestOperation*)authenticateWithNonce:(NSString*)nonce block:(APIBlock)block {
    NSAssert(self.authUrl, @"auth url missing");
    
    AFHTTPRequestOperationManager *manager = [self.class manager];
    
    NSDictionary* params = nil;
    
    if (_userIdOverride) {
        params = @{@"nonce": nonce, @"layer_id": _userIdOverride};
    }
    else {
        params = @{@"nonce": nonce};
    }
    
    return [manager POST:self.authUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject[@"response"][@"identity"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

@end
