//
//  SpotifyManager.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/16/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Spotify/Spotify.h>

@interface SpotifyManager : NSObject

@property(strong,nonatomic,readonly) BOOL loggedIn;

- (void)logIn;

- (BOOL)canHandleURL:(NSURL*)url;

- (void)handleAuthCallbackWithTriggeredAuthURL:(NSURL*)url;

@end
