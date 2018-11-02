//
//  WBTextUtils.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBTextUtils : NSObject

+ (BOOL)isMoney:(NSString *)text;
+ (BOOL)isDecimalNumber:(NSString *)text decimalPlaces:(NSUInteger)allowedDecimalPlaces;
+ (BOOL)isNonnegativeMoney:(NSString *)text;
+ (BOOL)isNonnegativeInteger:(NSString *)text;
+ (BOOL)isProperName:(NSString *)name;
+ (NSString *)omitIllegalCharacters:(NSString *)text;

@end
