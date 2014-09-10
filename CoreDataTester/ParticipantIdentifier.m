//
//  UserIdentifier.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/9/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "ParticipantIdentifier.h"

@implementation ParticipantIdentifier

@dynamic identifier, conversation;

- (BOOL)validateIdentifier:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"identifier must be non-NULL"}];
        }
        return NO;
    }
    return YES;
}

- (BOOL)validateConversation:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"conversation must be non-NULL"}];
        }
        return NO;
    }
    return YES;
}

@end
