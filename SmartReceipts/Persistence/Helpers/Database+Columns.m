//
//  Database+Columns.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

@import FMDB;
#import "Database+Columns.h"
#import "DatabaseTableNames.h"
#import "Database+Functions.h"
#import "ReceiptColumn.h"
#import "FMDatabase.h"
#import "DatabaseQueryBuilder.h"

@implementation Database (Columns)

- (BOOL)createColumnsTableWithName:(NSString *)tableName {
    
    // DON'T UPDATE THIS SCHEME, YOU CAN DO IT JUST THROUGH MIGRATION
    
    NSArray *createTable = @[
            @"CREATE TABLE ", tableName, @" (",
            CSVTable.COLUMN_ID, @" INTEGER PRIMARY KEY AUTOINCREMENT, ",
            CSVTable.COLUMN_TYPE, @" TEXT", @");"
    ];
    return [self executeUpdateWithStatementComponents:createTable];
}

- (NSArray *)fetchAllColumnsFromTable:(NSString *)tableName {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ ASC", tableName, CSVTable.COLUMN_CUSTOM_ORDER_ID];

    NSMutableArray *loaded = [[NSMutableArray alloc] init];

    [self.databaseQueue inDatabase:^(FMDatabase* database){
        FMResultSet* resultSet = [database executeQuery:query];

        while ([resultSet next]) {
            ReceiptColumn *col = [ReceiptColumn columnType:[resultSet intForColumn:CSVTable.COLUMN_COLUMN_TYPE]];
            [col loadDataFromResultSet:resultSet];
            [loaded addObject:col];
        }

    }];

    return [NSArray arrayWithArray:loaded];
}

- (BOOL)replaceAllColumnsInTable:(NSString *)tableName columns:(NSArray *)columns {
    __block BOOL result;
    
    BOOL oldDatabase = [self databaseVersion] < 18;
    [self.databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollback){
        NSString *query = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        result = [database executeUpdate:query];
        if (!result) {
            *rollback = YES;
            return;
        }
        
        for (Column *col in columns) {
            // Need to avoid issues with legacy columns replacement
            BOOL result = oldDatabase
                ? [self insertWithColumnName:col.name intoTable:tableName customOrderId:col.customOrderId uuid:col.uuid usingDatabase:database]
                : [self insertWithColumnType:col.сolumnType intoTable:tableName customOrderId:col.customOrderId uuid:col.uuid usingDatabase:database];
            
            if (!result) {
                *rollback = YES;
                return;
            }
        }

        result = YES;
    }];
    return result;
}

- (BOOL)insertWithColumnType:(NSInteger)columnType intoTable:(NSString *)tableName customOrderId:(NSInteger)customOrderId uuid:(NSString *)uuid usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *insert = [DatabaseQueryBuilder insertStatementForTable:tableName];
    [insert addParam:CSVTable.COLUMN_COLUMN_TYPE value:@(columnType)];
    if ([database version] >= DatabaseMigrator.UUIDVersion) {
        NSString *_uuid = uuid ? uuid : [[NSUUID UUID] UUIDString];
        [insert addParam:CommonColumns.ENTITY_UUID value:_uuid];
    }
    if (customOrderId >= 0) {
        [insert addParam:CSVTable.COLUMN_CUSTOM_ORDER_ID value:@(customOrderId)];
    }
    return [self executeQuery:insert usingDatabase:database];
}

- (BOOL)insertWithColumnName:(NSString *)columnName intoTable:(NSString *)tableName customOrderId:(NSInteger)customOrderId uuid:(NSString *)uuid usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *insert = [DatabaseQueryBuilder insertStatementForTable:tableName];
    [insert addParam:CSVTable.COLUMN_TYPE value:columnName];
    if ([database version] >= DatabaseMigrator.UUIDVersion) {
        NSString *_uuid = uuid ? uuid : [[NSUUID UUID] UUIDString];
        [insert addParam:CommonColumns.ENTITY_UUID value:_uuid];
    }
    if (customOrderId >= 0) {
        [insert addParam:CSVTable.COLUMN_CUSTOM_ORDER_ID value:@(customOrderId)];
    }
    return [self executeQuery:insert usingDatabase:database];
}

- (BOOL)setCustomOrderId:(NSInteger)customOrderId forColumn:(Column *)column table:(NSString *)table usingDatabase:(FMDatabase *)db {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:table];
    [update addParam:CSVTable.COLUMN_CUSTOM_ORDER_ID value:@(customOrderId)];
    [update where:CSVTable.COLUMN_ID value:@(column.objectId)];
    return [self executeQuery:update usingDatabase:db];
}

- (BOOL)reorderColumn:(Column *)columnOne withColumn:(Column *)columnTwo table:(NSString *)table {
    if (columnOne.customOrderId == columnTwo.customOrderId) {
        return YES;
    }
    
    __block BOOL result;
    [self.databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        result = [self reorderColumn:columnOne withColumn:columnTwo table:table usingDB:db];
        *rollback = result ? NO : YES;
    }];
    
    return result;
}

- (BOOL)reorderColumn:(Column *)columnOne withColumn:(Column *)columnTwo table:(NSString *)table usingDB:(FMDatabase *)db {
    BOOL isNewOrderIdGreater = columnOne.customOrderId < columnTwo.customOrderId;
    NSInteger newCustomOrderIdTwo = isNewOrderIdGreater ? columnTwo.customOrderId - 1 : columnTwo.customOrderId + 1;
    
    BOOL result = [self setCustomOrderId:columnTwo.customOrderId forColumn:columnOne table:table usingDatabase:db];
    
    if (result) {
        NSString *operation = isNewOrderIdGreater ? @"-1" : @"+1";
        
        NSInteger minId = MIN(columnOne.customOrderId, newCustomOrderIdTwo);
        NSInteger maxId = MAX(columnOne.customOrderId, newCustomOrderIdTwo);
        
        NSArray *components = @[
                                @"UPDATE ", table,
                                [NSString stringWithFormat:@" SET %@ = %@%@ ",CSVTable.COLUMN_CUSTOM_ORDER_ID, CSVTable.COLUMN_CUSTOM_ORDER_ID, operation],
                                @" WHERE ", CSVTable.COLUMN_CUSTOM_ORDER_ID,
                                @" BETWEEN ", @(minId).stringValue, @" AND ", @(maxId).stringValue];
        
        NSString *query = [components componentsJoinedByString:@""];
        DatabaseQueryBuilder *update = [DatabaseQueryBuilder rawQuery:query];
        result &= [self executeQuery:update usingDatabase:db];
    }
    
    result &= [self setCustomOrderId:newCustomOrderIdTwo forColumn:columnTwo table:table usingDatabase:db];
    
    return result;
}

- (NSInteger)nextCustomOrderIdForColumnTable:(NSString *)table {
    __block NSInteger result = 0;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSArray *components = @[@"SELECT ", CSVTable.COLUMN_CUSTOM_ORDER_ID, @" FROM ", table,
                                @" ORDER BY ", CSVTable.COLUMN_CUSTOM_ORDER_ID, @" DESC LIMIT 1"];
        NSString *query = [components componentsJoinedByString:@""];
        result = (NSInteger)[db intForQuery:query];
    }];
    return result + 1;
}

- (BOOL)addColumn:(Column *)column table:(NSString *)table {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self insertWithColumnType:column.сolumnType intoTable:table customOrderId:column.customOrderId uuid:column.uuid usingDatabase:db];
    }];
    return result;
}

- (BOOL)removeColumn:(Column *)column table:(NSString *)table{
    DatabaseQueryBuilder *delete = [DatabaseQueryBuilder deleteStatementForTable:table];
    [delete where:CSVTable.COLUMN_ID value:@(column.objectId)];
    return [self executeQuery:delete];
}

@end
