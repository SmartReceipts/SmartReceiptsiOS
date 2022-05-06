//
//  Database+Categories.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

@import FMDB;
#import "Database+Categories.h"
#import "WBCategory.h"
#import "Database+Functions.h"
#import "FetchedModelAdapter.h"
#import "DatabaseQueryBuilder.h"
#import "DatabaseTableNames.h"
#import "Database+Notify.h"

@interface WBCategory (Expose)

@property (nonatomic, copy) NSString *originalName;

@end

@implementation Database (Categories)

- (BOOL)createCategoriesTable {
    
    // DON'T UPDATE THIS SCHEME, YOU CAN DO IT JUST THROUGH MIGRATION
    
    NSArray *createCategoriesTable = @[
            @"CREATE TABLE ", CategoriesTable.TABLE_NAME, @" (",
            CategoriesTable.COLUMN_NAME, @" TEXT, ",
            CategoriesTable.COLUMN_CODE, @" TEXT, ",
            CategoriesTable.COLUMN_BREAKDOWN, @" BOOLEAN DEFAULT 1", @");"
    ];
    return [self executeUpdateWithStatementComponents:createCategoriesTable];
}

- (NSArray *)listAllCategories {
    return [[self fetchedAdapterForCategories] allObjects];
}

- (BOOL)saveCategory:(WBCategory *)category {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self saveCategory:category usingDatabase:db];
    }];
    return result;
}

- (BOOL)saveCategory:(WBCategory *)category usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *insert = [DatabaseQueryBuilder insertStatementForTable:CategoriesTable.TABLE_NAME];
    [insert addParam:CategoriesTable.COLUMN_CODE value:category.code];
    [insert addParam:CategoriesTable.COLUMN_NAME value:category.name];
    NSString *uuid = category.uuid ? category.uuid : [[NSUUID UUID] UUIDString];
    [insert addParam:CommonColumns.ENTITY_UUID value:uuid];
    
    if (category.objectId != 0) {
        [insert addParam:CategoriesTable.COLUMN_ID value:@(category.objectId)];
    }
    if (category.customOrderId >= 0) {
        [insert addParam:CategoriesTable.COLUMN_CUSTOM_ORDER_ID value:@(category.customOrderId)];
    }
    BOOL result = [self executeQuery:insert usingDatabase:database];
    if (result) {
        [self notifyInsertOfModel:category];
    }
    return result;
}

- (BOOL)updateCategory:(WBCategory *)category {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:CategoriesTable.TABLE_NAME];
    [update addParam:CategoriesTable.COLUMN_CODE value:category.code];
    [update addParam:CategoriesTable.COLUMN_NAME value:category.name];
    [update addParam:CategoriesTable.COLUMN_CUSTOM_ORDER_ID value:@(category.customOrderId)];
    [update where:CategoriesTable.COLUMN_ID value:@(category.objectId)];
    BOOL result = [self executeQuery:update];
    if (result) {
        [self notifyUpdateOfModel:category];
    }
    return result;
}

- (WBCategory *)categoryByName:(NSString *)name {
    for (WBCategory *category in self.listAllCategories) {
        if ([category.name isEqualToString:name]) {
            return category;
        }
    }
    return [[WBCategory alloc] initWithName:name code:name.uppercaseString customOrderId:[self nextCustomOrderIdForCategory]];
}

- (WBCategory *)categoryByID:(NSInteger)categoryId {
    for (WBCategory *category in self.listAllCategories) {
        if (category.objectId == categoryId) {
            return category;
        }
    }
    return nil;
}

- (BOOL)setCustomOrderId:(NSInteger)customOrderId forCategory:(WBCategory *)category usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:CategoriesTable.TABLE_NAME];
    [update addParam:CategoriesTable.COLUMN_CUSTOM_ORDER_ID value:@(customOrderId)];
    [update where:CategoriesTable.COLUMN_ID value:@(category.objectId)];
    return [self executeQuery:update usingDatabase:database];
}

- (BOOL)reorderCategory:(WBCategory *)categoryOne withCategory:(WBCategory *)categoryTwo {
    if (categoryOne.customOrderId == categoryTwo.customOrderId) {
        return YES;
    }
    
    __block BOOL result;
    
    [self.databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        result = [self reorderCategory:categoryOne withCategory:categoryTwo usingDatabase:db];
        *rollback = result ? NO : YES;
    }];
    
    if (result) {
        NSArray *changedModels = [self categoriesBetweenCategoryOne:categoryOne categoryTwo:categoryTwo];
        [self notifyReorderOfModels:changedModels];
    }
    
    return result;
}

- (NSArray *)categoriesBetweenCategoryOne:(WBCategory *)categoryOne categoryTwo:(WBCategory *)categoryTwo {
    NSInteger minId = MIN(categoryOne.customOrderId, categoryTwo.customOrderId);
    NSInteger maxId = MAX(categoryOne.customOrderId, categoryTwo.customOrderId);
    
    NSArray *components = @[@"SELECT * FROM ", CategoriesTable.TABLE_NAME,
                            @" WHERE ", CategoriesTable.COLUMN_CUSTOM_ORDER_ID,
                            @" BETWEEN ", @(minId).stringValue, @" AND ", @(maxId).stringValue,
                            @" ORDER BY ", CategoriesTable.COLUMN_CUSTOM_ORDER_ID, @" ASC"];
    NSString *rawQuery = [components componentsJoinedByString:@""];
    DatabaseQueryBuilder *select = [DatabaseQueryBuilder rawQuery:rawQuery];
    FetchedModelAdapter *fetched = [self createAdapterUsingQuery:select forModel:[WBCategory class]];
    return fetched.allObjects;
}

- (BOOL)reorderCategory:(WBCategory *)categoryOne withCategory:(WBCategory *)categoryTwo usingDatabase:(FMDatabase *)database {
    BOOL isNewOrderIdGreater = categoryOne.customOrderId < categoryTwo.customOrderId;
    NSInteger newCustomOrderIdTwo = isNewOrderIdGreater ? categoryTwo.customOrderId - 1 : categoryTwo.customOrderId + 1;
    
    BOOL result = [self setCustomOrderId:categoryTwo.customOrderId forCategory:categoryOne usingDatabase:database];
    
    if (result) {
        NSString *operation = isNewOrderIdGreater ? @"-1" : @"+1";
        
        NSInteger minId = MIN(categoryOne.customOrderId, newCustomOrderIdTwo);
        NSInteger maxId = MAX(categoryOne.customOrderId, newCustomOrderIdTwo);
        
        NSArray *components = @[
                @"UPDATE ", CategoriesTable.TABLE_NAME,
                [NSString stringWithFormat:@" SET %@ = %@%@ ",CategoriesTable.COLUMN_CUSTOM_ORDER_ID, CategoriesTable.COLUMN_CUSTOM_ORDER_ID, operation],
                @" WHERE ", CategoriesTable.COLUMN_CUSTOM_ORDER_ID,
                @" BETWEEN ", @(minId).stringValue, @" AND ", @(maxId).stringValue];
        
        NSString *query = [components componentsJoinedByString:@""];
        DatabaseQueryBuilder *update = [DatabaseQueryBuilder rawQuery:query];
        result &= [self executeQuery:update usingDatabase:database];
    }
    
    result &= [self setCustomOrderId:newCustomOrderIdTwo forCategory:categoryTwo usingDatabase:database];
    
    return result;
}

- (BOOL)deleteCategory:(WBCategory *)category {
    DatabaseQueryBuilder *delete = [DatabaseQueryBuilder deleteStatementForTable:CategoriesTable.TABLE_NAME];
    [delete where:CategoriesTable.COLUMN_ID value:@(category.objectId)];
    BOOL result = [self executeQuery:delete];
    if (result) {
        [self notifyDeleteOfModel:category];
    }
    return result;
}

- (FetchedModelAdapter *)fetchedAdapterForCategories {
    DatabaseQueryBuilder *select = [DatabaseQueryBuilder selectAllStatementForTable:CategoriesTable.TABLE_NAME];
    [select orderBy:CategoriesTable.COLUMN_CUSTOM_ORDER_ID ascending:YES];
    return [self createAdapterUsingQuery:select forModel:[WBCategory class]];
}

- (NSInteger)nextCustomOrderIdForCategory {
    __block NSInteger result = 0;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSArray *components = @[@"SELECT ", CategoriesTable.COLUMN_CUSTOM_ORDER_ID, @" FROM ", CategoriesTable.TABLE_NAME,
                                @" ORDER BY ", CategoriesTable.COLUMN_CUSTOM_ORDER_ID, @" DESC LIMIT 1"];
        NSString *query = [components componentsJoinedByString:@""];
        result = (NSInteger)[db intForQuery:query];
    }];
    return result + 1;
}

@end
