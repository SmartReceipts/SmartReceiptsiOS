//
//  Database+PDFColumns.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@class Column;

@interface Database (PDFColumns)

- (BOOL)createPDFColumnsTable;
- (NSArray *)allPDFColumns;
- (BOOL)replaceAllPDFColumnsWith:(NSArray *)columns;
- (BOOL)reorderPDFColumn:(Column *)columnOne withPDFColumn:(Column *)columnTwo;
- (NSInteger)nextCustomOrderIdForPDFColumn;
- (BOOL)addPDFColumn:(Column *)column;
- (NSInteger)nextPDFColumnObjectID;
- (BOOL)removePDFColumn:(Column *)column;
@end
