//
//  ReceiptColumnPaymentMethod.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 15/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnPaymentMethod.h"
#import "WBReceipt.h"
#import "LocalizedString.h"
#import <SmartReceipts-Swift.h>

@implementation ReceiptColumnPaymentMethod

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    return receipt.paymentMethod ? receipt.paymentMethod.method : LocalizedString(@"undefined", nil);
}

@end
