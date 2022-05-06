//
//  WBCategory.m
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

@import FMDB;
#import "WBCategory.h"
#import "DatabaseTableNames.h"
#import "LocalizedString.h"

static NSString *const TABLE_NAME = @"categories";
static NSString *const COLUMN_NAME = @"name";
static NSString *const COLUMN_CODE = @"code";
static NSString *const COLUMN_BREAKDOWN = @"breakdown";
static NSString *const COLUMN_CUSTOM_ORDER_ID = @"custom_order_id";

@interface WBCategory ()

@property (nonatomic, copy) NSString *originalName;

@end

@implementation WBCategory

- (id)initWithName:(NSString *)name code:(NSString *)code {
    return [self initWithName:name code:code customOrderId:0];
}

- (id)initWithName:(NSString *)name code:(NSString *)code uuid:(NSString *)uuid {
    return [self initWithName:name code:code customOrderId:0 objectId:0 uuid:uuid];
}
    
- (id)initWithName:(NSString *)name code:(NSString *)code customOrderId:(NSInteger)customOrderId {
    return [self initWithName:name code:code customOrderId:customOrderId objectId:0];
}

- (id)initWithName:(NSString *)name code:(NSString *)code customOrderId:(NSInteger)customOrderId objectId:(NSInteger)objectId {
    return [self initWithName:name code:code customOrderId:customOrderId objectId:objectId uuid:@""];
}

- (id)initWithName:(NSString *)name code:(NSString *)code customOrderId:(NSInteger)customOrderId objectId:(NSInteger)objectId uuid:(NSString *)uuid {
    self = [super init];
    if (self) {
        _objectId = objectId;
        _name = name;
        _originalName = name;
        _code = code;
        _customOrderId = customOrderId;
        _uuid = uuid;
    }
    return self;
}

+ (NSString *)CATEGORY_NAME_BREAKFAST {
    return LocalizedString(@"category_breakfast", nil);
}

+ (NSString *)CATEGORY_NAME_LUNCH {
    return LocalizedString(@"category_lunch", nil);
}

+ (NSString *)CATEGORY_NAME_DINNER {
    return LocalizedString(@"category_dinner", nil);
}

+ (NSDictionary *)namesToCodeMapFromCategories:(NSArray *)categories {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (WBCategory *category in categories) {
        dict[category.name] = category.code;
    }
    return dict;
}

- (void)loadDataFromResultSet:(FMResultSet *)resultSet {
    _objectId = [resultSet intForColumn:CategoriesTable.COLUMN_ID];
    _code = [resultSet stringForColumn:CategoriesTable.COLUMN_CODE];
    _name = [resultSet stringForColumn:CategoriesTable.COLUMN_NAME];
    _customOrderId = [resultSet intForColumn:CategoriesTable.COLUMN_CUSTOM_ORDER_ID];
    _uuid = [resultSet stringForColumn:CommonColumns.ENTITY_UUID];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    WBCategory *category = other;

    return [self.name isEqualToString:category.name] && self.objectId == category.objectId;
}

- (NSUInteger)hash {
    return self.name.hash;
}

- (void)setName:(NSString *)name {
    _name = [name mutableCopy];

    if (!self.originalName) {
        [self setOriginalName:name];
    }
}

- (NSString *)presentedValue {
    return self.name;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name: %@", self.name];
    [description appendString:@">"];
    return description;
}

@end
