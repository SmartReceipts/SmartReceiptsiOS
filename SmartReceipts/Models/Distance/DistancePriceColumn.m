//
//  DistancePriceColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistancePriceColumn.h"
#import <SmartReceipts-Swift.h>

@implementation DistancePriceColumn

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV {
    Price *price = distance.totalRate;
    return (forCSV ? price.amountAsString : price.currencyFormattedPrice);
}

- (NSString *)valueForFooter:(NSArray *)rows forCSV:(BOOL)forCSV {
    PricesCollection *collection = [PricesCollection new];
    for (Distance *distance in rows) {
        [collection addPrice:distance.totalRate];
    }
    return [collection currencyFormattedTotalPriceWithIgnoreEmpty:NO];
}

@end
