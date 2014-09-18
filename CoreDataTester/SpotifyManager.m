//
//  SpotifyManager.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/16/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "SpotifyManager.h"


#define kSessionArchiveName @"spt_session"

static NSString * const kClientId = @"24a1ebf9e8124c4f93d61a96f6d5ce02";
static NSString * const kCallbackURL = @"heynow://spotify-callback";

static NSString * const kTokenSwapServiceURL = @"http://localhost:5000/api/v1/auth_spotify?auth_token=f3c4ee55-fc54-44a9-ab7b-27215e7aa746";
static NSString * const kTokenRefreshServiceURL = @"http://localhost:5000/api/v1/refresh_spotify?auth_token=f3c4ee55-fc54-44a9-ab7b-27215e7aa746";


@interface SpotifyManager ()

@property(strong,nonatomic) SPTSession* session;

@end

@implementation SpotifyManager

- (id)init {
    self = [super init];
    if (self) {
        [self loadSession];
    }
    return self;
}


- (void)logIn {
    NSURL *loginPageURL = [[SPTAuth defaultInstance] loginURLForClientId:kClientId
                                                     declaredRedirectURL:[NSURL URLWithString:kCallbackURL]
                                                                  scopes:@[SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthUserLibraryRead]];
    
    [[UIApplication sharedApplication] openURL:loginPageURL];
}

- (BOOL)loggedIn {
    return self.session.isValid;
}

- (BOOL)canHandleURL:(NSURL*)url {
    return [[SPTAuth defaultInstance] canHandleURL:url withDeclaredRedirectURL:[NSURL URLWithString:kCallbackURL]];
}

- (void)handleAuthCallbackWithTriggeredAuthURL:(NSURL*)url {
    SPTAuthCallback authCallback = ^(NSError *error, SPTSession *session) {
        
        if (error) {
            NSLog(@"spotify auth error %@", error);
            return;
        }
        
        self.session = session;
        [self saveSession];
    };
    
    [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url
                                        tokenSwapServiceEndpointAtURL:[NSURL URLWithString:kTokenSwapServiceURL]
                                                             callback:authCallback];
}

#pragma mark - Sessions

- (void)renewSession:(SPTSession*)session {
    SPTAuth *auth = [SPTAuth defaultInstance];
    [auth renewSession:session withServiceEndpointAtURL:[NSURL URLWithString:kTokenRefreshServiceURL] callback:^(NSError *error, SPTSession *session) {
        if (error) {
            NSLog(@"*** Error renewing session: %@", error);
            return;
        }
        
        // enable audio playback here
    }];
}

- (void)loadSession {
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionArchiveName];
    if (data) {
        SPTSession* session = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (session.isValid) {
            self.session = session;
        }
        else {
            // renew token
            [self renewSession:session];
        }
    }
}

- (void)saveSession {
    if (self.session) {
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.session];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kSessionArchiveName];
    }
}

- (void)clearSession {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSessionArchiveName];
}

- (NSString*)sessionFilePath {
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [docPath stringByAppendingPathComponent:kSessionArchiveName];
}

@end
