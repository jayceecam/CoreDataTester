//
//  BaseAPI.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/14/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "BaseAPI.h"

#import <KeychainItemWrapper/KeychainItemWrapper.h>


@implementation BaseAPI

NSString *const KeychainAuthenticationTokenKey = @"com.acme.Acme";

static KeychainItemWrapper *keychainItem = nil;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KeychainAuthenticationTokenKey accessGroup:nil];
    });
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


+ (AFHTTPRequestOperationManager*)manager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return manager;
}

+ (AFHTTPRequestOperationManager*)managerWithTimeout:(NSTimeInterval)timeoutInterval {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if (timeoutInterval > 0)
        manager.requestSerializer.timeoutInterval = timeoutInterval;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return manager;
}

+ (void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlockWithDeserialization:(DeserilizationBlock)deserializationBlock successHandling:(SuccessHandleBlock)successBlock apiBlock:(APIBlock)block {
    return ^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responseObject %@", responseObject);
        
        [self checkForErrorInRequest:operation response:responseObject block:block okBlock:^{
            id jsonResponse = responseObject[@"response"];
            NSLog(@"jsonResponse %@ for request %@", jsonResponse, operation.request);
            
            if (deserializationBlock) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0L), ^{
                    id ob = deserializationBlock(jsonResponse);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!operation.isCancelled) {
                            id ob2 = successBlock ? successBlock(ob) : ob;
                            if (block) block(ob2, nil);
                        }
                    });
                });
            }
            else {
                id ob = successBlock ? successBlock(jsonResponse) : jsonResponse;
                if (block) block(ob, nil);
            }
        }];
    };
}

+ (void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlockWithDeserialization:(DeserilizationBlock)deserializationBlock asyncSuccessHandling:(AsyncSuccessHandleBlock)asyncSuccessBlock apiBlock:(APIBlock)block {
    return ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self checkForErrorInRequest:operation response:responseObject block:block okBlock:^{
            id jsonResponse = responseObject[@"response"];
            NSLog(@"jsonResponse %@ for request %@", jsonResponse, operation.request);
            
            if (deserializationBlock) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0L), ^{
                    id ob = deserializationBlock(jsonResponse);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!operation.isCancelled) {
                            if (asyncSuccessBlock) {
                                asyncSuccessBlock(ob, ^(id obOut) {
                                    if (block) block(obOut, nil);
                                });
                            }
                            else if (block) {
                                block(ob, nil);
                            }
                        }
                    });
                });
            }
            else {
                if (asyncSuccessBlock) {
                    asyncSuccessBlock(jsonResponse, ^(id obOut) {
                        if (block) block(obOut, nil);
                    });
                }
                else if (block) {
                    block(jsonResponse, nil);
                }
            }
        }];
    };
}

+ (void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock:(APIBlock)block {
    return ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    };
}


#pragma mark - Util

+ (void)checkForErrorInRequest:(AFHTTPRequestOperation*)requestOp response:(id)response block:(APIBlock)block okBlock:(void(^)())okBlock {
    if (![self handlePotentialError:requestOp response:response block:block]) {
        if (okBlock) okBlock();
    }
}

+ (BOOL)handlePotentialError:(AFHTTPRequestOperation*)requestOp response:(id)response block:(APIBlock)block {
    if (![self wasSuccess:response]) {
        if (block) block(nil, [self error:response]);
        return YES;
    }
    return NO;
}

+ (NSString*)requestStatus:(id)response {
    id ob;
    if ([response isKindOfClass:[NSDictionary class]]) {
        ob = [response objectForKey:@"request"];
        if ([ob isKindOfClass:[NSDictionary class]]) {
            ob = [ob objectForKey:@"status"];
            if ([ob isKindOfClass:[NSString class]]) {
                return ob;
            }
        }
    }
    return nil;
}

+ (BOOL)wasSuccess:(id)response {
    return [[self requestStatus:response] isEqualToString:@"ok"];
}

+ (NSString*)errorMessage:(id)response {
    if ([[self requestStatus:response] isEqualToString:@"error"]) {
        NSString* errorReason = [[response objectForKey:@"request"] objectForKey:@"error_message"];
        return errorReason;
    }
    return @"Unknown server issue";
}

+ (NSError*)error:(id)response {
    NSLog(@"handling json error %@", response);
    if ([[self requestStatus:response] isEqualToString:@"error"]) {
        NSString* errorReason = [[response objectForKey:@"request"] objectForKey:@"error_message"];
        NSNumber* errorCode = [[response objectForKey:@"request"] objectForKey:@"error_code"];
        NSInteger code = !!errorCode ? errorCode.integerValue : -1;
        NSError* err = [NSError errorWithDomain:kErrorDomainAcme code:code userInfo:[NSDictionary dictionaryWithObject:errorReason forKey:NSLocalizedDescriptionKey]];
        return err;
    }
    return BaseAPIErrorWithDescription(@"Unknown server issue");
}


NSError* BaseAPIErrorWithDescription(NSString* description) {
    if (description) {
        NSLog(@"err %@", description);
        
        NSError* error = [NSError errorWithDomain:kErrorDomainAcme code:-1 userInfo:[NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey]];
        return error;
    }
    else {
        NSError* error = [NSError errorWithDomain:kErrorDomainAcme code:-1 userInfo:nil];
        return error;
    }
}


#pragma mark - Auth

+ (NSString*)username {
    return [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
}

+ (NSString*)password {
    return [keychainItem objectForKey:(__bridge id)kSecValueData];
}

+ (BOOL)hasAuth {
    return !!self.username.length && !!self.password.length;
}

+ (void)clearAuth {
    [keychainItem resetKeychainItem];
}

+ (void)setUsername:(NSString*)username andPassword:(NSString*)password {
    // TODO: also store locally in an encrypted file to avoid issues reading from keystore so frequently
    [keychainItem setObject:username forKey:(__bridge id)kSecAttrAccount];
    [keychainItem setObject:password forKey:(__bridge id)kSecValueData];
}

+ (void)resetUsernameAndPassword {
    NSLog(@"resetting keychain");
    [keychainItem resetKeychainItem];
}


@end
