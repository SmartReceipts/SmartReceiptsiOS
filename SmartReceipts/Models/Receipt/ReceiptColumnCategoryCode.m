//
//  ReceiptColumnCategoryCode.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnCategoryCode.h"
#import "WBReceipt.h"
#import <SmartReceipts-Swift.h>

@implementation ReceiptColumnCategoryCode

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    return [receipt.category code];
}

@end
