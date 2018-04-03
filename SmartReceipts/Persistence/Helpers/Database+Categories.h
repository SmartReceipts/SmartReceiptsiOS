//
//  Database+Categories.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@class WBCategory;
@class FetchedModelAdapter;
@class FMDatabase;

@interface Database (Categories)

- (BOOL)createCategoriesTable;
- (NSArray<WBCategory *> *)listAllCategories;
- (BOOL)saveCategory:(WBCategory *)category;
- (BOOL)updateCategory:(WBCategory *)category;
- (BOOL)swapCategory:(WBCategory *)categoryOne withCategory:(WBCategory *)categoryTwo;
- (BOOL)reorderCategory:(WBCategory *)categoryOne withCategory:(WBCategory *)categoryTwo;
- (BOOL)deleteCategory:(WBCategory *)category;
- (WBCategory *)categoryByName:(NSString *)name;
- (WBCategory *)categoryByID:(NSInteger )categoryId;
- (FetchedModelAdapter *)fetchedAdapterForCategories;
- (NSInteger)nextCustomOrderIdForCategory;

@end
