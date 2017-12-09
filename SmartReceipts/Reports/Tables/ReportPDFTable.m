//
//  ReportPDFTable.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReportPDFTable.h"
#import "WBPdfDrawer.h"
#import "Column.h"

static inline NSString *safeString(NSString *str) {
    return str ? str : @"";
}

@interface ReportPDFTable ()

@property (nonatomic, strong) PrettyPDFRender *pdfRender;

@end

@implementation ReportPDFTable

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
        NSMutableArray *array = [NSMutableArray array];
        for (Column *column in self.columns) {
            NSString *header = [column.header stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
            [array addObject:safeString(header)];
        }
        [self.pdfRender appendTableWithHeaders:array];
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

    [self.pdfRender closeTable];
}

@end
