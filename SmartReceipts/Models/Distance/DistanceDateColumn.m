//
//  DistanceDateColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistanceDateColumn.h"
#import "WBDateFormatter.h"
#import <SmartReceipts-Swift.h>

@implementation DistanceDateColumn

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV {
    return [self.dateFormatter formattedDate:distance.date inTimeZone:distance.timeZone];
}

@end
