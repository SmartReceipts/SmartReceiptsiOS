//
//  RateApplicationTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 13/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Constants.h"
#import "NSDate+Calculations.h"
#import "SmartReceipts-Swift.h"
@class RateApplicationManager;

@interface RateApplicationTest : XCTestCase

@property (nonatomic, strong) RateApplicationManager *rate;

@end

@implementation RateApplicationTest

- (void)setUp {
    [super setUp];

    self.rate = [[RateApplicationManager alloc] init];
    [self.rate reset];
    [self.rate setLaunchCount:SmartReceiptTargetLaunchesForAppRating];
    [self.rate setFirstLaunchDate:[[NSDate date] dateByAddingDays:-8]];
}

- (void)tearDown {
    [super tearDown];
    
    [self.rate reset];
}

- (void)testOnAppCrashRatingNotShown {
    XCTAssertTrue(self.rate.shouldShowRateDialog);
    [self.rate markAppCrash];
    XCTAssertFalse(self.rate.shouldShowRateDialog);
}

- (void)testNoShowWhenUsedBelowOneWeek {
    [self.rate setFirstLaunchDate:[[NSDate date] dateByAddingDays:-6]];

    XCTAssertFalse([self.rate shouldShowRateDialog]);
}

- (void)testNoShowWhenLaunchesBelowTarget {
    [self.rate setLaunchCount:SmartReceiptTargetLaunchesForAppRating - 10];

    XCTAssertFalse([self.rate shouldShowRateDialog]);
}

- (void)testShown {
    XCTAssertTrue([self.rate shouldShowRateDialog]);
}

- (void)testLaunchMarkerIncreasesLaunchCount {
    [self.rate setLaunchCount:10];
    [self.rate markAppLaunch];
    XCTAssertEqual(11, [self.rate launchCount]);
}

- (void)testLaterWillIncreaseTargetBySpecifiedAmount {
    XCTAssertEqual(SmartReceiptTargetLaunchesForAppRating, [self.rate launchTarget]);
    [self.rate rateLater];
    XCTAssertEqual(SmartReceiptTargetLaunchesForAppRating + SmartReceiptDelayedLaunchesOnAppRatingLater, [self.rate launchTarget]);
}

- (void)testAfterRatePressedNoMoreAlertShown {
    XCTAssertTrue(self.rate.shouldShowRateDialog);
    [self.rate markRatePressed];
    XCTAssertFalse(self.rate.shouldShowRateDialog);
}

- (void)testAfterNoPressedNoMoreAlertShown {
    XCTAssertTrue(self.rate.shouldShowRateDialog);
    [self.rate markNoPressed];
    XCTAssertFalse(self.rate.shouldShowRateDialog);
}

- (void)testOnFirstLaunchLaunchDateMarked {
    [self.rate setFirstLaunchDate:nil];
    XCTAssertNil([self.rate firstLaunchDate]);
    [self.rate markAppLaunch];
    XCTAssertEqualWithAccuracy([NSDate date].timeIntervalSince1970, [self.rate firstLaunchDate].timeIntervalSince1970, 1);
}

@end
