//
//  ReceiptColumnReportEndDate.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnReportEndDate.h"
#import "WBReceipt.h"
#import "WBTrip.h"
#import "WBDateFormatter.h"

@implementation ReceiptColumnReportEndDate

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    return [self.dateFormatter formattedDate:[receipt.trip endDate] inTimeZone:[receipt.trip endTimeZone]];
}

@end
