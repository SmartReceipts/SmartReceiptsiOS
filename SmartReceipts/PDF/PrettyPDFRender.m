//
//  PrettyPDFRender.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 09/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PrettyPDFRender.h"
#import "PDFPage.h"
#import "UIView+LoadHelpers.h"
#import "TripReportHeader.h"
#import "PDFReportTable.h"
#import "PDFImageView.h"
#import "FullPagePDFImageView.h"
#import "PDFPageRenderView.h"
#import "FullPagePDFPageView.h"

NSUInteger const SRMinNumberOfTableRowsForPage = 3;

@interface PDFReportTable (Expose)

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, assign) NSUInteger rowToStart;

@end

@interface PDFPage (Expose)

@property (nonatomic, assign) NSUInteger imageIndex;

@end

@interface PrettyPDFRender ()

@property (nonatomic, strong) PDFPage *writingToPage;
@property (nonatomic, strong) TripReportHeader *header;
@property (nonatomic, strong) PDFReportTable *openTable;

@end

@implementation PrettyPDFRender

- (instancetype)init {
    self = [super init];
    if (self) {

    }

    return self;
}

- (BOOL)setOutputPath:(NSString *)path {
    return UIGraphicsBeginPDFContextToFile(path, self.openPage.bounds, nil);
}

- (void)setTripName:(NSString *)tripName {
    [self.header setTripName:tripName];
}

- (void)appendHeaderRow:(NSString *)row {
    [self.header appendRow:row];
}

- (void)closeHeader {
    [self.openPage appendHeader:self.header];
}

- (BOOL)renderPages {
    
    // Sometimes there are no content on page. We don't render empty pages as it causes an extra page appearing
    if (![self.openPage isEmpty]) {
        [self renderPage:self.openPage];
    } else {
        LOGGER_WARNING(@"prevented rendering of the empty pdf page");
    }
    
    UIGraphicsEndPDFContext();
    
    if (self.tableHasTooManyColumns) {
        return NO;
    } else {
        return YES;
    }
}

- (void)renderPage:(PDFPage *)page {
    UIGraphicsBeginPDFPageWithInfo(page.bounds, nil);
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [page.layer renderInContext:pdfContext];
}

- (TripReportHeader *)header {
    if (!_header) {
        _header = [TripReportHeader loadInstance];
    }

    return _header;
}

- (PDFPage *)openPage {
    if (!self.writingToPage) {
        [self startNextPage];
    }

    return self.writingToPage;
}


- (void)startTable {
    self.openTable = [PDFReportTable loadInstance];
    [self.openTable setFrame:CGRectMake(0, 0, CGRectGetWidth(self.header.frame), 100)];
}

- (void)appendTableHeaders:(NSArray *)columnNames {
    [self.openTable setColumns:columnNames];
}

- (void)appendTableColumns:(NSArray *)rowValues {
    [self.openTable appendValues:rowValues];
}

- (void)closeTable {
    BOOL fullyAddedTable = [self.openTable buildTable:[self.openPage remainingSpace]];
    [self.openPage appendTable:self.openTable];
    
    if (self.openTable.hasTooManyColumnsToFitWidth) {
        _tableHasTooManyColumns = YES;
    }
    
    if (fullyAddedTable) {
        return;
    }

    PDFReportTable *partialTable = self.openTable;
    NSUInteger remainder = partialTable.rows.count - partialTable.rowsAdded;
    if (partialTable.rowToStart == 0 && (partialTable.rowsAdded < SRMinNumberOfTableRowsForPage || remainder < SRMinNumberOfTableRowsForPage)) {
        [self.openTable removeFromSuperview];
        [self startNextPage];
        [self.openTable setRowToStart:partialTable.rowsAdded];
        [self closeTable];
        return;
    }

    [self startNextPage];
    [self startTable];
    [self.openTable setColumns:partialTable.columns];
    [self.openTable setRows:partialTable.rows];
    [self.openTable setRowToStart:partialTable.rowsAdded];
    [self closeTable];
}

- (void)startNextPage {
    if (self.writingToPage) {
        [self renderPage:self.writingToPage];
    }

    PDFPage *newPage = [PDFPage loadInstance];
    
    if (self.landscapePreferred) {
        newPage.frame = kPDFPageA4Landscape;
    } else {
        newPage.frame = kPDFPageA4Portrait;
    }
    [newPage layoutIfNeeded];
    
    self.writingToPage = newPage;
}

- (void)appendImage:(UIImage *)image withLabel:(NSString *)label {
    
    
    if (self.openPage.imageIndex == 4) {
        [self startNextPage];
    }

    PDFImageView *imageView = [PDFImageView loadInstance];
    [imageView.titleLabel setText:label];
    [imageView.imageView setImage:image];
    [imageView fitImageView];

    [self.openPage appendImage:imageView];
}

- (void)appendFullPageImage:(UIImage *)image withLabel:(NSString *)label {
    if (![self.openPage isEmpty]) {
        [self startNextPage];
    }

    FullPagePDFImageView *imageView = [FullPagePDFImageView loadInstance];
    [imageView.titleLabel setText:label];
    [imageView.imageView setImage:image];
    [imageView fitImageView];

    [self.openPage appendImage:imageView];
    [self startNextPage];
}

- (void)appendPDFPage:(CGPDFPageRef)page withLabel:(NSString *)label {
    if (![self.openPage isEmpty]) {
        [self startNextPage];
    }
    
    CGRect cropBox = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    if (CGRectIsEmpty(cropBox) || CGRectEqualToRect(cropBox, CGRectNull) || CGRectEqualToRect(cropBox, CGRectZero)) {
        LOGGER_ERROR(@"appendPDFPage:withLabel: - page has invalid kCGPDFCropBox, label = %@", label);
    }
    
    FullPagePDFPageView *pdfPageRenderView = [FullPagePDFPageView loadInstance];
    [pdfPageRenderView.titleLabel setText:label];
    [pdfPageRenderView.pageRenderView setPage:page];
    [self.openPage appendFullPageElement:pdfPageRenderView];
    [self startNextPage];
}

@end
