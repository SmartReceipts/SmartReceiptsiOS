//
//  Database+CSVColumns.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database+CSVColumns.h"
#import "Database+Columns.h"
#import "DatabaseTableNames.h"
#import <SmartReceipts-Swift.h>

@interface Database (ColumnsExpose)

- (BOOL)createColumnsTableWithName:(NSString *)tableName;
- (NSArray *)fetchAllColumnsFromTable:(NSString *)tableName;
- (BOOL)replaceAllColumnsInTable:(NSString *)tableName columns:(NSArray *)columns;

@end

@implementation Database (CSVColumns)

- (BOOL)createCSVColumnsTable {
    return [self createColumnsTableWithName:CSVTable.TABLE_NAME];
}

- (NSArray *)allCSVColumns {
    return [self fetchAllColumnsFromTable:CSVTable.TABLE_NAME];
}

- (BOOL)replaceAllCSVColumnsWith:(NSArray *)columns {
    return [self replaceAllColumnsInTable:CSVTable.TABLE_NAME columns:columns];
}

- (BOOL)reorderCSVColumn:(Column *)columnOne withCSVColumn:(Column *)columnTwo {
    return [self reorderColumn:columnOne withColumn:columnTwo table:CSVTable.TABLE_NAME];
}

- (NSInteger)nextCustomOrderIdForCSVColumn {
    return [self nextCustomOrderIdForColumnTable:CSVTable.TABLE_NAME];
}

- (BOOL)addCSVColumn:(Column *)column {
    return [self addColumn:column table:CSVTable.TABLE_NAME];
}

- (NSInteger)nextCSVColumnObjectID {
    return [self nextAutoGeneratedIDForTable:CSVTable.TABLE_NAME];
}

- (BOOL)removeCSVColumn:(Column *)column {
    return [self removeColumn:column table:CSVTable.TABLE_NAME];
}

@end
