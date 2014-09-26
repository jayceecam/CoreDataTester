//
//  Message.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/8/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "Message.h"





@implementation Message

@dynamic identifier, creatorIdentifier, kind, hidden, removed, read, createdDate, conversation;

@synthesize lyrMessage;


- (void)awakeFromInsert {
    [super awakeFromInsert];
    self.removed = @NO;
    self.hidden = @NO;
    self.read = @NO;
}

- (void)awakeFromFetch {
    [super awakeFromFetch];
}

- (BOOL)isSent {
    return self.lyrMessage.isSent;
}

- (NSDictionary*)recipientStatusByUserID {
    return self.lyrMessage.recipientStatusByUserID;
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

- (BOOL)validateRead:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"read must be non-NULL"}];
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
    if ([*ioValue integerValue] == MessageKindAll) {
        if (outError) {
            *outError = [NSError errorWithDomain:kErrorDomainData code:0 userInfo:@{NSLocalizedDescriptionKey : @"kind cannot be MessageKindAll"}];
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
