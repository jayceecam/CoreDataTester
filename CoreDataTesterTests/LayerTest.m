//
//  LayerTest.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/10/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <LayerKit/LayerKit.h>
#import <AFNetworking/AFNetworking.h>


@interface LayerTest : XCTestCase <LYRClientDelegate>

@property(strong,nonatomic) LYRClient* layerClient;

@end




@implementation LayerTest

- (void)setUp {
    [super setUp];
    
    NSUUID *appID = [[NSUUID alloc] initWithUUIDString:@"2ed63e76-2c84-11e4-a2c3-8edc000001f6"];

    _layerClient = [LYRClient clientWithAppID:appID];
    _layerClient.delegate = self;
}

- (void)tearDown {
    
    _layerClient = nil;
    
    [super tearDown];
}

- (void)testLayerConnection {
    
    XCTestExpectation *layerConnectExpectation = [self expectationWithDescription:@"layer connect"];
    
    [_layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        XCTAssert(success);
        
        if (error) {
            NSLog(@"error %@", error.localizedDescription);
        }
        
        XCTAssert(!error);
        
        [layerConnectExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        
    }];
}

- (void)testLayerAuth {
    
    NSLog(@"testing..");
    
    XCTestExpectation *layerAuthExpectation = [self expectationWithDescription:@"layer auth"];
    
    // auth block to run for test
    void (^authBlock)(void) = ^{
        [_layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
            NSLog(@"Authentication nonce %@", nonce);
            
            if (error) {
                NSLog(@"error %@", error.localizedDescription);
            }
            
            XCTAssert(!error);
            
            if (!error) {
                [self obtainIdentityTokenWithNonce:nonce completion:^(NSString *identitiyToken, NSError *error) {
                    
                    NSLog(@"identity token %@", identitiyToken);
                    
                    if (error) {
                        NSLog(@"error %@", error.localizedDescription);
                    }
                    
                    XCTAssert(!error);
                    
                    if (!error) {
                        [_layerClient authenticateWithIdentityToken:identitiyToken completion:^(NSString *authenticatedUserID, NSError *error) {
                            NSLog(@"Authenticated as %@", authenticatedUserID);
                            
                            if (error) {
                                NSLog(@"error %@", error.localizedDescription);
                            }
                            
                            XCTAssert(!error);
                            
                            [layerAuthExpectation fulfill];
                        }];
                    }
                    
                }];
            }
        }];
    };
    
    // connection
    [_layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        XCTAssert(success);
        
        if (error) {
            NSLog(@"error %@", error.localizedDescription);
        }
        
        XCTAssert(!error);
        
        // deauthorize if needed
        if (_layerClient.authenticatedUserID) {
            [_layerClient deauthenticateWithCompletion:^(BOOL success, NSError *error) {
                if (error) {
                    NSLog(@"error %@", error.localizedDescription);
                }
                
                XCTAssert(!error);
                
                authBlock();
            }];
        }
        else {
            authBlock();
        }
    }];
    
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        
    }];
}


- (void)obtainIdentityTokenWithNonce:(NSString*)nonce completion:(void(^)(NSString* identitiyToken, NSError*error))block {
    static NSString * const BaseURLString = @"http://localhost:5000/api/v1/auth_layer";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary* params = @{@"nonce": nonce, @"id": @(1)};
    
    [manager POST:BaseURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject[@"response"][@"identity"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}


#pragma mark LayerDelegate

- (void)layerClient:(LYRClient *)client didFailSynchronizationWithError:(NSError *)error {
    NSLog(@"Layer Cliend did fail Synchronization with error:%@", error);
    
    
}

- (void)layerClient:(LYRClient *)client didReceiveAuthenticationChallengeWithNonce:(NSString *)nonce {
    NSLog(@"teset");
    
    [self obtainIdentityTokenWithNonce:nonce completion:^(NSString *identitiyToken, NSError *error) {
        XCTAssert(!error);
        
        [_layerClient authenticateWithIdentityToken:identitiyToken completion:^(NSString *remoteUserID, NSError *error) {
            XCTAssert(!error);
            
            if (!error) {
                NSLog(@"Successful Auth with userID %@", remoteUserID);
            }
            else {
                NSLog(@"Client did fail authentication with Error:%@", error);
            }
        }];
    }];
}

- (void)layerClient:(LYRClient *)client didAuthenticateAsUserID:(NSString *)userID {
    
}

- (void)layerClientDidDeauthenticate:(LYRClient *)client {
    
}

@end
