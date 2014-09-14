//
//  LayerManager.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/10/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "LayerManager.h"

#import "DataAccessor.h"


@implementation LayerManager


- (id)init {
    self = [super init];
    if (self) {
        
        NSUUID *appID = [[NSUUID alloc] initWithUUIDString:@"63f95df4-3774-11e4-bc37-c86404003b52"];
        
        _client = [LYRClient clientWithAppID:appID];
        _client.delegate = self;
        
        [self connect];
    }
    return self;
}


#pragma mark - Public

- (void)connect {
    [_client connectWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            
        }
        if (error) {
            
        }
    }];
}



#pragma mark - LayerDelegate

- (void)layerClient:(LYRClient *)client didFinishSynchronizationWithChanges:(NSArray *)changes {
    NSLog(@"Layer Client did finish synchronization");
    
    for (NSDictionary *change in changes) {
        id changeObject = [change objectForKey:LYRObjectChangeObjectKey];
        if ([changeObject isKindOfClass:[LYRConversation class]]) {
            LYRConversation* conversation = changeObject;
            LYRObjectChangeType updateKey = (LYRObjectChangeType)[[change objectForKey:LYRObjectChangeTypeKey] integerValue];
            switch (updateKey) {
                case LYRObjectChangeTypeCreate:
                    //
                    break;
                case LYRObjectChangeTypeUpdate:
                    //
                    break;
                case LYRObjectChangeTypeDelete:
                    //
                    break;
            }
        }
        else {
            LYRMessage* message = changeObject;
            LYRObjectChangeType updateKey = (LYRObjectChangeType)[[change objectForKey:LYRObjectChangeTypeKey] integerValue];
            switch (updateKey) {
                case LYRObjectChangeTypeCreate:
                    //
                    break;
                case LYRObjectChangeTypeUpdate:
                    //
                    break;
                case LYRObjectChangeTypeDelete:
                    //
                    break;
            }
        }
    }
}

- (void)layerClient:(LYRClient *)client didFailSynchronizationWithError:(NSError *)error {
    NSLog(@"Layer Cliend did fail Synchronization with error:%@", error);
    
    
}

- (void)layerClient:(LYRClient *)client didReceiveAuthenticationChallengeWithNonce:(NSString *)nonce {
    NSLog(@"teset");
}

- (void)layerClient:(LYRClient *)client didAuthenticateAsUserID:(NSString *)userID {
    
}

- (void)layerClientDidDeauthenticate:(LYRClient *)client {
    
}



@end
