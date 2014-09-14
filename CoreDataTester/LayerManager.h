//
//  LayerManager.h
//  CoreDataTester
//
//  Created by Joe Cerra on 9/10/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <LayerKit/LayerKit.h>


@interface LayerManager : NSObject <LYRClientDelegate>

@property(strong,nonatomic) LYRClient* client;

- (void)connect;

- (void)disconnect;



@end
