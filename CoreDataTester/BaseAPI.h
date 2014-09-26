//
//  BaseAPI.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/14/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


#define kErrorDomainAcme @"error.domain.acme"


typedef void (^APIBlock)(id result, NSError* error);
typedef void (^APIImageBlock)(UIImage* image, NSError* error);


typedef id(^SuccessHandleBlock)(id ob);
typedef id(^DeserilizationBlock)(id responseJson);


typedef void(^AsyncSuccessCompletionBlock)(id ob);
typedef void(^AsyncSuccessHandleBlock)(id ob, AsyncSuccessCompletionBlock continueBlock);



@interface BaseAPI : NSObject


+ (AFHTTPRequestOperationManager*)manager;

+ (AFHTTPRequestOperationManager*)managerWithTimeout:(NSTimeInterval)timeoutInterval;

+ (void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlockWithDeserialization:(DeserilizationBlock)deserializationBlock successHandling:(SuccessHandleBlock)successBlock apiBlock:(APIBlock)block;

+ (void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlockWithDeserialization:(DeserilizationBlock)deserializationBlock asyncSuccessHandling:(AsyncSuccessHandleBlock)asyncSuccessBlock apiBlock:(APIBlock)block;

+ (void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock:(APIBlock)block;


#pragma mark - Auth

+ (BOOL)hasAuth;
+ (void)clearAuth;

+ (void)setUsername:(NSString*)username andPassword:(NSString*)password;
+ (void)setUserIdForTesting:(NSString*)userId;

@end
