//
//  DistanceLocationColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistanceLocationColumn.h"
#import "LocalizedString.h"
#import <SmartReceipts-Swift.h>

@implementation DistanceLocationColumn

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV {
    return distance.location;
}

- (NSString *)valueForFooter:(NSArray *)rows forCSV:(BOOL)forCSV {
    return [WBPreferences localizedWithKey:@"total"];
}

@end
