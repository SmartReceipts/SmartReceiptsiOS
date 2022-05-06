//
//  Database+Hints.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 11/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

@import FMDB;
#import "Database+Hints.h"
#import "FMDatabase.h"
#import "DatabaseTableNames.h"

@implementation Database (Hints)

- (NSArray *)hintForTripBasedOnEntry:(NSString *)entry {
    return [self hintFromTable:TripsTable.TABLE_NAME column:TripsTable.COLUMN_NAME baseOnEntry:entry];
}

- (NSArray *)hintForReceiptBasedOnEntry:(NSString *)entry {
    return [self hintFromTable:ReceiptsTable.TABLE_NAME column:ReceiptsTable.COLUMN_NAME baseOnEntry:entry];
}

- (NSArray *)hintFromTable:(NSString *)tableName column:(NSString *)columnName baseOnEntry:(NSString *)entry {
    NSString *q = [NSString stringWithFormat:@"SELECT DISTINCT TRIM(%@) AS _id FROM %@ WHERE %@ LIKE ? ORDER BY %@", columnName, tableName, columnName, columnName];

    NSString *like = [NSString stringWithFormat:@"%@%%", entry];

    __block NSMutableArray *hints = [NSMutableArray new];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:q, like];
        while ([result next]) {
            [hints addObject:[result stringForColumn:@"_id"]];
        }
    }];
    return [NSArray arrayWithArray:hints];
}

@end
