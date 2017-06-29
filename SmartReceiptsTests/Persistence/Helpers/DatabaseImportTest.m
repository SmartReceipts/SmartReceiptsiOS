//
//  DatabaseImportTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "NSDate+Calculations.h"
#import "Database.h"
#import "Database+Import.h"
#import "Database+Functions.h"
#import "DatabaseTableNames.h"
#import "Database+PaymentMethods.h"
#import <SmartReceipts-Swift.h>

@interface DatabaseImportTest : SmartReceiptsTestsBase

@property (nonatomic, copy) NSString *testBasePath;
@property (nonatomic, copy) NSString *importBasePath;
@property (nonatomic, strong) Database *database;

@end

@implementation DatabaseImportTest

- (void)setUp {
    [super setUp];

    self.testBasePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"DBImport%@", [NSDate date].milliseconds]];
    [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"clean" ofType:@"db"] toPath:self.testBasePath error:nil];

    self.database = [[Database alloc] initWithDatabasePath:self.testBasePath tripsFolderPath:NSTemporaryDirectory()];
    [self.database open];
}

- (void)tearDown {
    [super tearDown];

    [[NSFileManager defaultManager] removeItemAtPath:self.testBasePath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.importBasePath error:nil];
}

- (void)testImportAndroidV11 {
    NSString *copied = [self copyForImport:[[NSBundle bundleForClass:[self class]] pathForResource:@"android-receipts-v11" ofType:@"db"]];
    [self.database importDataFromBackup:copied overwrite:NO];

    XCTAssertEqual(5, [self.database countRowsInTable:TripsTable.TABLE_NAME]);
    XCTAssertEqual(68, [self.database countRowsInTable:ReceiptsTable.TABLE_NAME]);
}

- (void)testImportAndroidV13 {
    NSString *copied = [self copyForImport:[[NSBundle bundleForClass:[self class]] pathForResource:@"android-receipts-v13" ofType:@"db"]];
    [self.database importDataFromBackup:copied overwrite:NO];

    XCTAssertEqual(1, [self.database countRowsInTable:TripsTable.TABLE_NAME]);
    XCTAssertEqual(1, [self.database countRowsInTable:ReceiptsTable.TABLE_NAME]);
}

- (void)testPaymentMethodsReplaceImport {
    NSArray *before = [self.database allPaymentMethods];
    XCTAssertEqual(5, before.count);

    [self performExtrasImport];

    NSArray *after = [self.database allPaymentMethods];
    XCTAssertEqual(6, after.count);
    BOOL foundMother, foundFather;
    for (PaymentMethod *method in after) {
        if ([method.method isEqualToString:@"Mother"]) {
            foundMother = YES;
        } else if ([method.method isEqualToString:@"Father"]) {
            foundFather = YES;
        }
    }
    XCTAssertTrue(foundMother && foundFather);
}

- (void)testCSVColumnsImport {
    //new set defined in import
    [self performExtrasImport];

    NSUInteger after = [self.database countRowsInTable:CSVTable.TABLE_NAME];
    XCTAssertEqual(2, after);
}

- (void)testPDFColumnsImport {
    [self performExtrasImport];

    NSUInteger after = [self.database countRowsInTable:PDFTable.TABLE_NAME];
    XCTAssertEqual(3, after);
}

- (void)performExtrasImport {
    NSString *copied = [self copyForImport:[[NSBundle bundleForClass:[self class]] pathForResource:@"exrtas-import-test" ofType:@"db"]];
    [self.database importDataFromBackup:copied overwrite:YES];
}

- (NSString *)copyForImport:(NSString *)originalPath {
    self.importBasePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"ImportedBase%@", [NSDate date].milliseconds]];
    [[NSFileManager defaultManager] copyItemAtPath:originalPath toPath:self.importBasePath error:nil];
    return self.importBasePath;
}

@end
