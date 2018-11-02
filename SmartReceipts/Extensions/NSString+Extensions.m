//
//  NSString+Extensions.m
//  SmartReceipts
//
//  Created by Victor on 2/1/17.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

- (BOOL)rangeExists:(NSRange)range {
    return range.location != NSNotFound && range.location + range.length <= self.length;
}


@end
