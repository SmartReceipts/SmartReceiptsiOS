//
//  Database+PDFColumns.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database+PDFColumns.h"
#import "DatabaseTableNames.h"
#import "Database+Columns.h"
#import <SmartReceipts-Swift.h>

@interface Database (ColumnsExpose)

- (BOOL)createColumnsTableWithName:(NSString *)tableName;
- (NSArray *)fetchAllColumnsFromTable:(NSString *)tableName;
- (BOOL)replaceAllColumnsInTable:(NSString *)tableName columns:(NSArray *)columns;

@end

@implementation Database (PDFColumns)

- (BOOL)createPDFColumnsTable {
    BOOL result = [self createColumnsTableWithName:PDFTable.TABLE_NAME];
    return result;
}

- (NSArray *)allPDFColumns {
    NSArray *result = [self fetchAllColumnsFromTable:PDFTable.TABLE_NAME];
    return result;
}

- (BOOL)replaceAllPDFColumnsWith:(NSArray *)columns {
    BOOL result = [self replaceAllColumnsInTable:PDFTable.TABLE_NAME columns:columns];
    return result;
}

- (BOOL)reorderPDFColumn:(Column *)columnOne withPDFColumn:(Column *)columnTwo {
    return [self reorderColumn:columnOne withColumn:columnTwo table:PDFTable.TABLE_NAME];
}

- (NSInteger)nextCustomOrderIdForPDFColumn {
    return [self nextCustomOrderIdForColumnTable:PDFTable.TABLE_NAME];
}

- (BOOL)addPDFColumn:(Column *)column {
    return [self addColumn:column table:PDFTable.TABLE_NAME];
}

- (NSInteger)nextPDFColumnObjectID {
    return [self nextAutoGeneratedIDForTable:PDFTable.TABLE_NAME];
}

- (BOOL)removePDFColumn:(Column *)column {
    return [self removeColumn:column table:PDFTable.TABLE_NAME];
}

@end
