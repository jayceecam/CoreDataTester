//
//  ParticipantIdentifier.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/9/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "Data.h"


@class Conversation;

@interface ParticipantIdentifier : NSManagedObject

@property(strong,nonatomic) NSString* identifier;

@property(strong,nonatomic) Conversation* conversation;

@end


