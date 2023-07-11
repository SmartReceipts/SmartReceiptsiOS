//
//  DistanceCurrencyColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistanceCurrencyColumn.h"
#import <SmartReceipts-Swift.h>

@implementation DistanceCurrencyColumn

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV {
    return distance.rate.currency.code;
}

- (NSString *)valueForFooter:(NSArray *)rows forCSV:(BOOL)forCSV {
    return [rows.firstObject trip].defaultCurrency.code;
}

@end
