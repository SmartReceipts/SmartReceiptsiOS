//
//  ReportPDFTable.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReportPDFTable.h"
#import "Column.h"
#import <SmartReceipts-Swift.h>

static inline NSString *safeString(NSString *str) {
    return str ? str : @"";
}

@interface ReportPDFTable ()

@property (nonatomic, strong) PrettyPDFRender *pdfRender;
@property (nonatomic) NSString *title;

@end

@implementation ReportPDFTable

- (instancetype)initWithTitle:(NSString *)title PDFRender:(PrettyPDFRender *)drawer columns:(NSArray *)columns {
    self = [self initWithPDFRender:drawer columns:columns];
    if (self) {
        _title = title;
    }
    return self;
}

- (instancetype)initWithPDFRender:(PrettyPDFRender *)drawer columns:(NSArray *)columns {
    self = [super initWithColumns:columns];
    if (self) {
        _pdfRender = drawer;
    }
    return self;
}

- (void)appendTableWithRows:(NSArray *)rows {
    [self.pdfRender startTable];
    
    if (self.includeHeaders) {
        [self.pdfRender appendTableWithHeaders:[self headers]];
    }
    if (self.includeFooters) {
        [self.pdfRender appendTableWithFooters:[self footersForRows:rows]];
    }
    

    for (id row in rows) {
        @autoreleasepool {
            NSMutableArray *array = [NSMutableArray array];
            for (Column *column in self.columns) {
                NSString *val = [column valueFromRow:row forCSV:NO];
                [array addObject:safeString(val)];
            }
            [self.pdfRender appendTableWithColumns:array];
        }
    }
    self.pdfRender.openTable.title = self.title;
    [self.pdfRender closeTable];
}

- (NSArray *)headers {
    NSMutableArray *headers = [NSMutableArray array];
    for (Column *column in self.columns) {
        [headers addObject:safeString(column.header)];
    }
    return headers;
}

- (NSArray *)footersForRows:(NSArray *)rows {
    NSMutableArray *footers = [NSMutableArray array];
    for (Column *column in self.columns) {
        NSString *val = [column valueForFooter:rows forCSV:NO];
        [footers addObject:safeString(val)];
    }
    return footers;
}

@end
