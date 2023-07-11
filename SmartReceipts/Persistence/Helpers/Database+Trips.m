//
//  Database+Trips.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 07/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

@import FMDB;
#import "Database+Trips.h"
#import "WBTrip.h"
#import "DatabaseTableNames.h"
#import "Database+Functions.h"
#import "DatabaseQueryBuilder.h"
#import "Database+Receipts.h"
#import "WBPreferences.h"
#import "Database+Distances.h"
#import "FetchedModelAdapter.h"
#import "NSDate+Calculations.h"
#import "Database+Notify.h"
#import "ReceiptFilesManager.h"
#import <SmartReceipts-Swift.h>

@interface WBTrip (Expose)

@property (nonatomic, copy) NSString *originalName;

- (BOOL)nameChanged;
- (NSString *)directoryPathUsingName:(NSString *)name;

@end

@implementation Database (Trips)

- (BOOL)createTripsTable {
    
    // DON'T UPDATE THIS SCHEME, YOU CAN DO IT JUST THROUGH MIGRATION
    
    NSArray *createTripsTable = @[
            @"CREATE TABLE ", TripsTable.TABLE_NAME, @" (",
            TripsTable.COLUMN_NAME, @" TEXT PRIMARY KEY, ",
            TripsTable.COLUMN_FROM, @" DATE, ",
            TripsTable.COLUMN_TO, @" DATE, ",
            TripsTable.COLUMN_FROM_TIMEZONE, @" TEXT, ",
            TripsTable.COLUMN_TO_TIMEZONE, @" TEXT, ",
            TripsTable.COLUMN_PRICE, @" DECIMAL(10, 2) DEFAULT 0.00, ",
            TripsTable.COLUMN_MILEAGE, @" DECIMAL(10, 2) DEFAULT 0.00, ",
            TripsTable.COLUMN_COMMENT, @" TEXT, ",
            TripsTable.COLUMN_DEFAULT_CURRENCY, @" TEXT",
            @");"];
    return [self executeUpdateWithStatementComponents:createTripsTable];
}

- (BOOL)saveTrip:(WBTrip *)trip {
    trip.lastLocalModificationTime = [NSDate new];
    DatabaseQueryBuilder *insert = [DatabaseQueryBuilder insertStatementForTable:TripsTable.TABLE_NAME];
    [insert addParam:CommonColumns.ENTITY_UUID value:[[NSUUID UUID] UUIDString]];
    [self appendParamsFromTrip:trip toQuery:insert];
    BOOL result = [self executeQuery:insert];
    if (result) {
        [self notifyInsertOfModel:trip];
    }
    return result;
}

- (BOOL)updateTrip:(WBTrip *)trip {
    trip.lastLocalModificationTime = [NSDate new];
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:TripsTable.TABLE_NAME];
    [self appendParamsFromTrip:trip toQuery:update];
    [update where:TripsTable.COLUMN_ID value:@(trip.objectId)];

    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self executeQuery:update usingDatabase:db];
        if (trip.nameChanged) {
            [self.filesManager renameFolderForTrip:trip originalName:trip.originalName];
        }
    }];

    if (result) {
        [self notifyUpdateOfModel:trip];
    }

    return result;
}

- (void)appendParamsFromTrip:(WBTrip *)trip toQuery:(DatabaseQueryBuilder *)query {
    [query addParam:TripsTable.COLUMN_NAME value:trip.name];
    [query addParam:TripsTable.COLUMN_FROM value:trip.startDate.milliseconds];
    [query addParam:TripsTable.COLUMN_TO value:trip.endDate.milliseconds];
    [query addParam:TripsTable.COLUMN_FROM_TIMEZONE value:trip.startTimeZone.name];
    [query addParam:TripsTable.COLUMN_TO_TIMEZONE value:trip.endTimeZone.name];
    [query addParam:TripsTable.COLUMN_DEFAULT_CURRENCY value:trip.defaultCurrency.code];
    [query addParam:TripsTable.COLUMN_COMMENT value:trip.comment];
    [query addParam:TripsTable.COLUMN_COST_CENTER value:trip.costCenter];
    [query addParam:SyncStateColumns.LAST_LOCAL_MODIFICATION_TIME value:trip.lastLocalModificationTime.milliseconds];
}

- (NSDecimalNumber *)totalPriceForTrip:(WBTrip *)trip {
    __block NSDecimalNumber *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self totalPriceForTrip:trip usingDatabase:db];
    }];

    return result;
}

- (NSDecimalNumber *)totalPriceForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database {
    NSDecimalNumber *priceOfTrip = [self sumOfReceiptsForTrip:trip usingDatabase:database];
    if ([WBPreferences isTheDistancePriceBeIncludedInReports]) {
        priceOfTrip = [priceOfTrip decimalNumberByAdding:[self sumOfDistancesForTrip:trip usingDatabase:database]];
    }

    return priceOfTrip;
}

- (NSArray *)allTrips {
    __block NSArray *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self allTripsUsingDatabase:db];
    }];

    return result;
}

- (NSArray *)allTripsUsingDatabase:(FMDatabase *)database {
    FetchedModelAdapter *adapter = [[FetchedModelAdapter alloc] initWithDatabase:self];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC", TripsTable.TABLE_NAME, TripsTable.COLUMN_TO];
    [adapter setQuery:query];
    [adapter setModelClass:[WBTrip class]];
    [adapter fetchUsingDatabase:database];
    return [adapter allObjects];
}

- (FetchedModelAdapter *)fetchedAdapterForAllTrips {
    DatabaseQueryBuilder *selectAllTrips = [DatabaseQueryBuilder selectAllStatementForTable:TripsTable.TABLE_NAME];
    [selectAllTrips orderBy:TripsTable.COLUMN_TO ascending:NO];
    return [self createAdapterUsingQuery:selectAllTrips forModel:[WBTrip class]];
}

- (FetchedModelAdapter *)fetchedAdapterForAllTripsExcluding:(WBTrip *)trip {
    DatabaseQueryBuilder *selectAllTrips = [DatabaseQueryBuilder selectAllStatementForTable:TripsTable.TABLE_NAME];
    [selectAllTrips orderBy:TripsTable.COLUMN_TO ascending:NO];
    [selectAllTrips where:TripsTable.COLUMN_NAME notValue:trip.name];
    return [self createAdapterUsingQuery:selectAllTrips forModel:[WBTrip class]];
}

- (BOOL)deleteTrip:(WBTrip *)trip {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self deleteTrip:trip usingDatabase:db];
    }];

    return result;
}

- (BOOL)deleteTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *delete = [DatabaseQueryBuilder deleteStatementForTable:TripsTable.TABLE_NAME];
    [delete where:TripsTable.COLUMN_ID value:@(trip.objectId)];
    BOOL result = [self executeQuery:delete usingDatabase:database];
    if (result) {
        [self.filesManager deleteFolderForTrip:trip];
        [self deleteReceiptsForTrip:trip usingDatabase:database];
        [self deleteDistancesForTrip:trip usingDatabase:database];

        [self notifyDeleteOfModel:trip];
    }

    return result;
}

@end
