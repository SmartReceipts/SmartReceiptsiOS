//
//  Database+Columns.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@class Column;

@interface Database (Columns)

- (BOOL)reorderColumn:(Column *)columnOne withColumn:(Column *)columnTwo table:(NSString *)table;
- (NSInteger)nextCustomOrderIdForColumnTable:(NSString *)table;
- (BOOL)addColumn:(Column *)column table:(NSString *)table;
- (BOOL)removeColumn:(Column *)column table:(NSString *)table;

@end
