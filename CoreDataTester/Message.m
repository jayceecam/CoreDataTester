//
//  Message.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/8/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "Message.h"

@implementation Message

@dynamic identifier, creatorIdentifier, kind, hidden, removed, createdDate;

@dynamic conversation, parentMessage, linkedMessages;

@dynamic body, audience, photoUrl, linkUrl;

- (void)awakeFromInsert {
    [super awakeFromInsert];
    self.removed = @NO;
    self.hidden = @NO;
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

- (BOOL)validateHidden:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"hidden must be non-NULL"}];
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

- (BOOL)validateCreatorIdentifier:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"creatorIdentifier must be non-NULL"}];
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
    if ([*ioValue integerValue] < MKindAll || [*ioValue integerValue] > MKindMessageWhisper) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"kind out of acceptable range"}];
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

@end
