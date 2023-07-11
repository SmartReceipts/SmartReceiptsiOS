//
//  DistanceRateColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistanceRateColumn.h"
#import <SmartReceipts-Swift.h>

@implementation DistanceRateColumn

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV {
    Price *price = distance.rate;
    return (forCSV ? price.mileageRateAmountAsString : price.mileageRateCurrencyFormattedPrice);
}

@end
