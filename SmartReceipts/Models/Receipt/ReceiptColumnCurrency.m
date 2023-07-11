//
//  ReceiptColumnCurrency.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnCurrency.h"
#import "WBReceipt.h"
#import <SmartReceipts-Swift.h>

@implementation ReceiptColumnCurrency

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    return [[receipt currency] code];
}

- (NSString *)valueForFooter:(NSArray *)rows forCSV:(BOOL)forCSV {
    PricesCollection *total = [PricesCollection new];
    for (WBReceipt *receipt in rows) {
        [total addPrice:receipt.price];
    }
    return [total currenciesCount] > 1 ? [total formattedCurrencies] : @"";
}

@end
