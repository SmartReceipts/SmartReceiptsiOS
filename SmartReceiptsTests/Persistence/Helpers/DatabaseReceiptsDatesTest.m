//
//  DatabaseReceiptsDatesTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 20/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "WBTrip.h"
#import "DatabaseTestsHelper.h"
#import "DatabaseTableNames.h"
#import "NSDate+Calculations.h"

@interface Database (Expose)

- (NSTimeInterval)maxSecondForReceiptsInTrip:(WBTrip *)trip onDate:(NSDate *)date;

@end

@interface DatabaseReceiptsDatesTest : SmartReceiptsTestsBase

@property (nonatomic, strong) WBTrip *testTrip;

@end

@implementation DatabaseReceiptsDatesTest

- (void)setUp {
    [super setUp];

    self.testTrip = [self.db createTestTrip];

    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT: self.testTrip, ReceiptsTable.COLUMN_DATE: [[NSDate date] dateByAddingDays:-1]}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT: self.testTrip, ReceiptsTable.COLUMN_DATE: [[NSDate date] dateByAddingDays:-1]}];

    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT: self.testTrip, ReceiptsTable.COLUMN_DATE: [NSDate date]}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT: self.testTrip, ReceiptsTable.COLUMN_DATE: [NSDate date]}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT: self.testTrip, ReceiptsTable.COLUMN_DATE: [NSDate date]}];
}

- (void)testMaxSecondsYesterday {
    NSDate *date = [NSDate date];
    NSTimeInterval maxSeconds = [self.db maxSecondForReceiptsInTrip:self.testTrip onDate:[date dateByAddingDays:-1]];
    XCTAssertEqualWithAccuracy(date.secondsOfDay, maxSeconds, 1);
}

- (void)testMaxSecondsToday {
    NSDate *date = [NSDate date];
    NSTimeInterval maxSeconds = [self.db maxSecondForReceiptsInTrip:self.testTrip onDate:date];
    XCTAssertEqualWithAccuracy(date.secondsOfDay, maxSeconds, 1);
}

@end
