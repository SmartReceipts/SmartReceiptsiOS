//
//  SmartReceiptsTestsBase.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

@import FMDB;
#import <UIKit/UIKit.h>
#import "SmartReceiptsTestsBase.h"
#import "Database.h"
#import "DatabaseTestsHelper.h"
#import "WBPreferencesTestHelper.h"
#import "Database+Functions.h"
#import "FMDatabase.h"
#import "LoggerMacros-ObjC.h"
#import "Database+Notify.h"

@interface SmartReceiptsTestsBase ()

@property (nonatomic, strong) WBPreferencesTestHelper *preferencesHelper;
@property (nonatomic, copy) NSString *testTripsPath;

@end

@implementation SmartReceiptsTestsBase

- (NSString *)generateTestDBPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"test_db_%d", (int) [NSDate timeIntervalSinceReferenceDate]]];
}

- (NSString *)generateTestTripsPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"test_trips_%d", (int) [NSDate timeIntervalSinceReferenceDate]]];
}

- (void)setUp {
    self.testDBPath = self.generateTestDBPath;
    self.testTripsPath = self.generateTestTripsPath;

    [self setDb:[self createTestDatabase]];

    self.preferencesHelper = [[WBPreferencesTestHelper alloc] init];
    [self.preferencesHelper createPreferencesBackup];
}

- (void)tearDown {
    [self deleteTestDatabase];
    [self.preferencesHelper restorePreferencesBackup];
    [[NSFileManager defaultManager] removeItemAtPath:self.testTripsPath error:nil];
}

- (void)deleteTestDatabase {
    [self.db close];
    [self setDb:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.testDBPath error:nil];
}

- (DatabaseTestsHelper *)createTestDatabase {
    return [self createAndOpenDatabaseWithPath:@":memory:" migrated:YES];
}

- (DatabaseTestsHelper *)createMigratedDatabaseFromTemplate:(NSString *)templateName {
    NSString *inputPath = [[NSBundle bundleForClass:[self class]] pathForResource:templateName ofType:@"db"];
    NSError *copyError = nil;
    LOGGER_DEBUG(@"Copy %@ to %@", inputPath, self.testDBPath);
    [[NSFileManager defaultManager] copyItemAtPath:inputPath toPath:self.testDBPath error:&copyError];
    if (copyError) {
        LOGGER_ERROR(@"Copy failed %@", copyError);
    }
    DatabaseTestsHelper *db = [[DatabaseTestsHelper alloc] initWithDatabasePath:self.testDBPath tripsFolderPath:self.testTripsPath];
    [db open:YES];
    return db;
}

- (DatabaseTestsHelper *)createAndOpenUnmigratedDatabaseWithPath:(NSString *)path {
    return [self createAndOpenDatabaseWithPath:path migrated:NO];
}

- (DatabaseTestsHelper *)createAndOpenDatabaseWithPath:(NSString *)path migrated:(BOOL)migrated {
    DatabaseTestsHelper *db = [[DatabaseTestsHelper alloc] initWithDatabasePath:path tripsFolderPath:self.testTripsPath];
    [db setNotificationsDisabled:YES];
    [db open:migrated];
    return db;
}

- (void)checkDatabasesSame:(NSString *)pathToReferenceDB checked:(NSString *)pathToCheckedDB {
    XCTAssertTrue(([[NSFileManager defaultManager] fileExistsAtPath:pathToReferenceDB]));
    XCTAssertTrue(([[NSFileManager defaultManager] fileExistsAtPath:pathToCheckedDB]));

    Database *referenceDB = [self createAndOpenUnmigratedDatabaseWithPath:pathToReferenceDB];
    Database *checkedDB = [self createAndOpenUnmigratedDatabaseWithPath:pathToCheckedDB];
    XCTAssertNotNil(referenceDB);
    XCTAssertNotNil(checkedDB);

    XCTAssertEqual([referenceDB databaseVersion], [checkedDB databaseVersion]);

    NSArray *tablesInReference = [self tableNames:referenceDB.databaseQueue];
    NSArray *tablesInChecked = [self tableNames:checkedDB.databaseQueue];
    XCTAssertEqual(tablesInReference.count, tablesInChecked.count);
    XCTAssertTrue([tablesInReference isEqualToArray:tablesInChecked]);

    for (NSString *tableName in tablesInReference) {
        NSArray *tableColumnsInReference = [self columnsInTableNamed:tableName inDatabase:referenceDB.databaseQueue];
        NSArray *tableColumnsInChecked = [self columnsInTableNamed:tableName inDatabase:referenceDB.databaseQueue];
        XCTAssertTrue([tableColumnsInReference isEqualToArray:tableColumnsInChecked]);
    }
}

- (NSArray *)columnsInTableNamed:(NSString *)name inDatabase:(FMDatabaseQueue *)database {
    __block NSMutableArray *columns = [NSMutableArray array];
    [database inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat:@"PRAGMA table_info('%@')", name]];
        while ([resultSet next]) {
            [columns addObject:[resultSet stringForColumnIndex:1]];
        }
    }];
    return [columns sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray *)tableNames:(FMDatabaseQueue *)database {
    __block NSMutableArray *tables = [NSMutableArray array];
    [database inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"];
        while ([resultSet next]) {
            [tables addObject:[resultSet stringForColumnIndex:0]];
        }
    }];
    return [tables sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

@end
