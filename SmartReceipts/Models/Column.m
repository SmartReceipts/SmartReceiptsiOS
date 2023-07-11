//
//  Column.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Column.h"
#import "WBDateFormatter.h"
#import "Constants.h"
#import <SmartReceipts-Swift.h>

@interface Column ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) WBDateFormatter *dateFormatter;

@end

@implementation Column

- (instancetype)initWithIndex:(NSInteger)index type:(NSInteger)type name:(NSString *)name {
    self = [super init];
    if (self) {
        _customOrderId = index;
        _name = name;
        _сolumnType = type;
        _uuid = @"";
    }
    return self;
}

- (instancetype)initWithType:(NSInteger)type name:(NSString *)name {
    return [self initWithIndex:-1 type:type name:name];
}

- (void)loadDataFromResultSet:(FMResultSet *)resultSet {
    _objectId = [resultSet intForColumn:CSVTable.COLUMN_ID];
    _customOrderId = [resultSet intForColumn:CSVTable.COLUMN_CUSTOM_ORDER_ID];
    _сolumnType = [resultSet intForColumn:CSVTable.COLUMN_COLUMN_TYPE];
    _name = [ReceiptColumn columnType:_сolumnType].name;
    _uuid = [resultSet stringForColumn:CommonColumns.ENTITY_UUID];
}

- (WBDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[WBDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (NSString *)valueFromRow:(id)row forCSV:(BOOL)forCSV {
    ABSTRACT_METHOD
    return nil;
}

- (NSString *)valueForFooter:(NSArray *)rows forCSV:(BOOL)forCSV {
    ABSTRACT_METHOD
    return nil;
}

- (NSString *)header {
    NSInteger index = [self.name componentsSeparatedByString:@" "].count > 2 ? 0 : 1;
    NSString *result = self.name;
    for (NSUInteger i = 0; i < result.length; i++) {
        if ([self.name characterAtIndex:i] == ' ') {
            if (++index % 2 == 0) {
                NSRange range = NSMakeRange(i, 1);
                result = [result stringByReplacingCharactersInRange:range withString:@"\n"];
            }
        }
    }
    return result;
}



@end
