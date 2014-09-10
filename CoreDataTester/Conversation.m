//
//  Conversation.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/8/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "Conversation.h"

#import "Message.h"


@implementation Conversation

@dynamic identifier, kind, removed;

@dynamic linkedConversations, parentConversation, messages, messageTopic, lastMessage;

@dynamic participantIdentifiers;

- (void)awakeFromInsert {
    [super awakeFromInsert];
    self.removed = @NO;
}

- (BOOL)validateRemoved:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"removed must be non-NULL"}];
        }
        return NO;
    }
    return YES;
}

- (BOOL)validateParticipantIdentifiers:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"participantIdentifiers must be non-NULL"}];
        }
        return NO;
    }
    if ([*ioValue count] == 0) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"participantIdentifiers must be non-empty"}];
        }
        return NO;
    }
    return YES;
}

- (BOOL)validateIdentifier:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"identifier must be non-NULL"}];
        }
        return NO;
    }
    return YES;
}

- (BOOL)validateLastMessage:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"lastMessage must be non-NULL"}];
        }
        return NO;
    }
    Message* message = *ioValue;
    if (![message isKindOfClass:[Message class]]) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"lastMessage is wrong class"}];
        }
        return NO;
    }
    if (message.hidden.boolValue) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"lastMessage must not be hidden"}];
        }
        return NO;
    }
    if (message.removed.boolValue) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"lastMessage must not be removed"}];
        }
        return NO;
    }
    return YES;
}

- (BOOL)validateKind:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"kind must be non-NULL"}];
        }
    return NO;
    }
    if ([*ioValue integerValue] < CKindAll || [*ioValue integerValue] > CKindThread) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"kind out of acceptable range"}];
        }
        return NO;
    }
    return YES;
}

- (BOOL)validateForInsert:(NSError **)error {
    BOOL propertiesValid = [super validateForInsert:error];
    BOOL consistencyValid = [self validateConsistency:error];
    return (propertiesValid && consistencyValid);
}

- (BOOL)validateConsistency:(NSError **)error {
    if (self.parentConversation || self.messageTopic) {
        if (!self.parentConversation) {
            if (error) {
                *error = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"messageTopic set but does not have parentConversation"}];
            }
            return NO;
        }
        if (!self.messageTopic) {
            if (error) {
                *error = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"parentConversation set but does not have messageTopic"}];
            }
            return NO;
        }
        if ([self.messageTopic.conversation.identifier isEqualToString:self.identifier]) {
            if (error) {
                *error = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"messageTopic must belong to another conversation"}];
            }
            return NO;
        }
    }
    return YES;
}

@end
