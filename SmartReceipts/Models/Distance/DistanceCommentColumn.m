//
//  DistanceCommentColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistanceCommentColumn.h"
#import <SmartReceipts-Swift.h>

@implementation DistanceCommentColumn

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV {
    return distance.comment;
}

@end
