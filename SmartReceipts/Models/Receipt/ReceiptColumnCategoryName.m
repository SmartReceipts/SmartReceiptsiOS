//
//  ReceiptColumnCategoryName.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnCategoryName.h"
#import "WBReceipt.h"
#import <SmartReceipts-Swift.h>

@implementation ReceiptColumnCategoryName

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    return [receipt.category name];
}

@end
