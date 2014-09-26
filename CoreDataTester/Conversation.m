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

@dynamic identifier, kind, removed, createdDate;

@dynamic linkedConversations, parentConversation, messages, parentMessage, lastMessage, messageMeta;

@dynamic participantIdentifiers;

@synthesize lyrConversation;

- (void)awakeFromInsert {
    [super awakeFromInsert];
    self.removed = @NO;
    self.kind = @(ConversationKindUndefined);
    self.createdDate = [NSDate date];
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

- (BOOL)validateCreatedDate:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"createdDate must be non-NULL"}];
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
//        if (outError) {
//            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"lastMessage must be non-NULL"}];
//        }
        // alow nil lastMessage while waiting for conversation to be formulated
        return YES;
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
    if ([*ioValue integerValue] == ConversationKindAll) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"kind can not be ConversationKindAll"}];
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
    if (self.parentConversation || self.parentMessage) {
        if (!self.parentConversation) {
            if (error) {
                *error = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"parentMessage set but does not have parentConversation"}];
            }
            return NO;
        }
        if (!self.parentMessage) {
            if (error) {
                *error = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"parentConversation set but does not have parentMessage"}];
            }
            return NO;
        }
        if ([self.parentMessage.conversation.identifier isEqualToString:self.identifier]) {
            if (error) {
                *error = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"parentMessage must belong to another conversation"}];
            }
            return NO;
        }
    }
    return YES;
}

@end
