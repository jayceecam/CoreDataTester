//
//  EmbedlyTest.m
//  CoreDataTester
//
//  Created by Joe Cerra on 9/16/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "EmbedlyAPI.h"


#define kRun NO


@interface EmbedlyTest : XCTestCase

@property(strong,nonatomic) EmbedlyAPI* api;

@end



@implementation EmbedlyTest

- (void)setUp {
    [super setUp];
    
    _api = [[EmbedlyAPI alloc] init];
}

- (void)tearDown {
    _api = nil;
    
    [super tearDown];
}

- (void)testParseURL {
    
    if (!kRun) return;
    
    XCTestExpectation *embedlyExpectation = [self expectationWithDescription:@"embedly expectation"];
    
    [_api extractURL:[NSURL URLWithString:@"http://techcrunch.com/2013/03/26/embedly-now-goes-beyond-embedding-with-new-products-extract-display-for-making-sense-of-links-resizing-images/"] completionBlock:^(EmbedlyExtractionResult *result, NSError *error) {
        if (error) {
            NSLog(@"error %@", error);
        }
        
        XCTAssert(!error);
        
        XCTAssert(result.url);
        XCTAssert(result.originalURL);
        XCTAssert(result.title);
        XCTAssert(result.desc);
        XCTAssert(result.providerName);
        XCTAssert(result.providerURL);
        XCTAssert(result.providerDisplay);
        XCTAssert(result.faviconURL);
        XCTAssert(result.images.count);
        
        for (EmbedlyExtractionImage* image in result.images) {
            XCTAssert(image.width);
            XCTAssert(image.height);
            XCTAssert(image.size);
            XCTAssert(image.url);
        }
        
        [embedlyExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
    }];
}

@end
