//
//  Data.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/24/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "Data.h"

@implementation Data

+ (NSValueTransformer*)JSONSetTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^NSSet* (NSArray* items) {
        return [NSSet setWithArray:items];
    } reverseBlock:^NSArray* (NSSet* items) {
        return items.allObjects;
    }];
}

@end
