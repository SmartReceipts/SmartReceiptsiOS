//
//  DistanceDistanceColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistanceDistanceColumn.h"
#import <SmartReceipts-Swift.h>

@implementation DistanceDistanceColumn

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV {
    return [distance.distance descriptionWithLocale:[NSLocale currentLocale]];
}

- (NSString *)valueForFooter:(NSArray *)rows forCSV:(BOOL)forCSV {
    NSDecimalNumber *total = [NSDecimalNumber zero];
    for (Distance *distance in rows) {
        total = [total decimalNumberByAdding:distance.distance];
    }
    return [total descriptionWithLocale:[NSLocale currentLocale]];
}

@end
