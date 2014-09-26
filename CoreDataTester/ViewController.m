//
//  ViewController.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/8/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "ViewController.h"

#import "LayerManager.h"
#import "BaseAPI.h"
#import "AppDelegate.h"


@interface ViewController ()

@property(strong,nonatomic) NSString* layerId;

@property(strong,nonatomic) NSString* userId;

@property(strong,nonatomic) LayerManager* manager;

@property(strong,nonatomic) NSSet* participants;



@end



@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userId = @"2";
    
    _layerId = [NSString stringWithFormat:@"layer_test_%@", _userId];
    
    _manager = [[LayerManager alloc] initWithContext:((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext];
    _manager.layerAPI.authUrl = @"http://localhost:5000/api/v1/auth_layer";
    _manager.layerAPI.userIdOverride = _layerId;
    
    _participants = [NSSet setWithObjects:_layerId, @"layer_test_3", nil];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ConversationDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSLog(@"observed conversation change for %@ info %@", note.object, note.userInfo);
    }];
}

- (IBAction)deauthenticate:(id)sender {
    if (_manager.client.authenticatedUserID) {
        [_manager.client deauthenticateWithCompletion:^(BOOL success, NSError *error) {
            NSLog(@"deauth %i %@", success, error);
        }];
    }
}

- (IBAction)authenticateAndListen:(id)sender {
    [BaseAPI setUserIdForTesting:_userId];
    
    [_manager authenticate];
}

- (IBAction)beginTesting:(id)sender {
    Conversation* c = [_manager findOrCreateChatWithParticipantIds:_participants];
    [_manager sendPlainMessage:@"Hello Layer" inConversation:c completionBlock:^(Message *message, NSError *error) {
        NSLog(@"send message %@ error %@", message, error);
    }];
}

- (IBAction)wipeDB:(id)sender {
    NSURL *storeURL = ((AppDelegate*)[UIApplication sharedApplication].delegate).applicationDBURL;
    
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    
    [((AppDelegate*)[UIApplication sharedApplication].delegate) resetCoreData];
    
    _manager.managedObjectContext = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
}

@end
