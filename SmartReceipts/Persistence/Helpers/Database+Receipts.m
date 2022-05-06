//
//  Database+Receipts.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

@import FMDB;
#import "Database+Receipts.h"
#import "DatabaseTableNames.h"
#import "Database+Functions.h"
#import "WBReceipt.h"
#import "DatabaseQueryBuilder.h"
#import "WBTrip.h"
#import "FetchedModelAdapter.h"
#import "WBPreferences.h"
#import "Database+Trips.h"
#import "Database+PaymentMethods.h"
#import "Database+Notify.h"
#import "ReceiptFilesManager.h"
#import "NSDate+Calculations.h"
#import "Constants.h"
#import "SmartReceipts-Swift.h"

NSInteger const kDaysToOrderFactor = 1000;
static NSString * const kGreaterCompare = @" > ";
static NSString * const kGreaterOrEqualCompare = @" >= ";
static NSString * const kDeprecatedParent = @"parent";

@interface WBReceipt (Expose)

- (BOOL)dateChanged;

@end

@implementation Database (Receipts)

- (BOOL)createReceiptsTable {
    
    // DON'T UPDATE THIS SCHEME, YOU CAN DO IT JUST THROUGH MIGRATION
    
    NSArray *createReceiptsTable = @[
            @"CREATE TABLE ", ReceiptsTable.TABLE_NAME, @" (",
            ReceiptsTable.COLUMN_ID, @" INTEGER PRIMARY KEY AUTOINCREMENT, ",
            ReceiptsTable.COLUMN_PATH, @" TEXT, ",
            kDeprecatedParent, @" TEXT REFERENCES ", TripsTable.TABLE_NAME, @" ON DELETE CASCADE, ",
            ReceiptsTable.COLUMN_NAME, @" TEXT DEFAULT \"New Receipt\", ",
            ReceiptsTable.COLUMN_CATEGORY, @" TEXT, ",
            ReceiptsTable.COLUMN_DATE, @" DATE DEFAULT (DATE('now', 'localtime')), ",
            ReceiptsTable.COLUMN_TIMEZONE, @" TEXT, ",
            ReceiptsTable.COLUMN_COMMENT, @" TEXT, ",
            ReceiptsTable.COLUMN_ISO4217, @" TEXT NOT NULL, ",
            ReceiptsTable.COLUMN_PRICE, @" DECIMAL(10, 2) DEFAULT 0.00, ",
            ReceiptsTable.COLUMN_TAX, @" DECIMAL(10, 2) DEFAULT 0.00, ",
            ReceiptsTable.COLUMN_PAYMENTMETHOD, @" TEXT, ",
            ReceiptsTable.COLUMN_REIMBURSABLE, @" BOOLEAN DEFAULT 1, ",
            ReceiptsTable.COLUMN_NOTFULLPAGEIMAGE, @" BOOLEAN DEFAULT 1, ",
            ReceiptsTable.COLUMN_EXTRA_EDITTEXT_1, @" TEXT, ",
            ReceiptsTable.COLUMN_EXTRA_EDITTEXT_2, @" TEXT, ",
            ReceiptsTable.COLUMN_EXTRA_EDITTEXT_3, @" TEXT",
        @");"];
    return [self executeUpdateWithStatementComponents:createReceiptsTable];
}

- (BOOL)saveReceipt:(WBReceipt *)receipt {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self saveReceipt:receipt usingDatabase:db];
    }];

    return result;
}

- (BOOL)saveReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database {
    if (receipt.objectId == 0) {
        return [self insertReceipt:receipt usingDatabase:database];
    } else {
        return [self updateReceipt:receipt usingDatabase:database];
    }
}

- (BOOL)insertReceipt:(WBReceipt *)receipt {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self insertReceipt:receipt usingDatabase:db];
    }];
    
    return result;
}

- (BOOL)insertReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *insert = [DatabaseQueryBuilder insertStatementForTable:ReceiptsTable.TABLE_NAME];
    [self appendCommonValuesFromReceipt:receipt toQuery:insert];
    
    NSInteger customOrderId = [self customOrderIdForDate:receipt.date inTrip:receipt.trip usingDatabase:database];
    [insert addParam:ReceiptsTable.COLUMN_CUSTOM_ORDER_ID value:@(customOrderId)];
    [insert addParam:CommonColumns.ENTITY_UUID value:[[NSUUID UUID] UUIDString]];

    BOOL result = [self executeQuery:insert usingDatabase:database];
    if (result) {
        [self notifyInsertOfModel:receipt];
        [self notifyUpdateOfModel:receipt.trip];
    }
    return result;
}

- (BOOL)updateReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:ReceiptsTable.TABLE_NAME];
    [self appendCommonValuesFromReceipt:receipt toQuery:update];
    
    if (receipt.dateChanged) {
        [self updateOrderIdGroupOfReceipt:receipt compare:kGreaterCompare increment:NO usingDatabase:database];
        NSInteger customOrderId = [self customOrderIdForDate:receipt.date inTrip:receipt.trip usingDatabase:database];
        [update addParam:ReceiptsTable.COLUMN_CUSTOM_ORDER_ID value:@(customOrderId)];
    }
    
    [update where:ReceiptsTable.COLUMN_ID value:@(receipt.objectId)];
    BOOL result = [self executeQuery:update usingDatabase:database];
    if (result) {
        [self notifyUpdateOfModel:receipt];
        [self notifyUpdateOfModel:receipt.trip];
    }
    return result;
}

- (BOOL)deleteReceipt:(WBReceipt *)receipt {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self deleteReceipt:receipt usingDatabase:db];
    }];

    return result;
}

- (BOOL)deleteReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *delete = [DatabaseQueryBuilder deleteStatementForTable:ReceiptsTable.TABLE_NAME];
    [delete where:ReceiptsTable.COLUMN_ID value:@(receipt.objectId)];
    BOOL result = [self executeQuery:delete usingDatabase:database];
    if (result) {
        [self.filesManager deleteFileForReceipt:receipt];
        [self notifyDeleteOfModel:receipt];
        [self notifyUpdateOfModel:receipt.trip];
    }
    return result;
}

- (NSArray *)allReceiptsForTrip:(WBTrip *)trip {
    return [self allReceiptsForTrip:trip ascending:false];
}

- (NSArray *)allReceiptsForTrip:(WBTrip *)trip ascending:(BOOL)isAscending {
    DatabaseQueryBuilder *selectAll = [WBReceipt selectAllQueryForTrip:trip isAscending:isAscending];
    return [self allReceiptsWithQuery:selectAll forTrip:trip];
}

- (NSArray *)allReceiptsWithQuery:(DatabaseQueryBuilder *)query forTrip:(WBTrip *)trip {
    FetchedModelAdapter *adapter = [self createAdapterUsingQuery:query forModel:[WBReceipt class] associatedModel:trip];
    NSArray *receipts = [adapter allObjects];
    return receipts;
}

- (NSDecimalNumber *)sumOfReceiptsForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database {
    return [self sumOfReceiptsForTrip:trip onlyReimbursableReceipts:[WBPreferences onlyIncludeReimbursableReceiptsInReports] usingDatabase:database];
}

- (NSDecimalNumber *)sumOfReceiptsForTrip:(WBTrip *)trip onlyReimbursableReceipts:(BOOL)onlyReimbursable {
    __block NSDecimalNumber *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self sumOfReceiptsForTrip:trip onlyReimbursableReceipts:onlyReimbursable usingDatabase:db];
    }];

    return result;
}

- (NSDecimalNumber *)sumOfReceiptsForTrip:(WBTrip *)trip onlyReimbursableReceipts:(BOOL)onlyReimbursable usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *sumStatement = [DatabaseQueryBuilder sumStatementForTable:ReceiptsTable.TABLE_NAME];
    [sumStatement setSumColumn:ReceiptsTable.COLUMN_PRICE];
    [sumStatement where:ReceiptsTable.COLUMN_PARENT_ID value:@(trip.objectId)];
    if (onlyReimbursable) {
        [sumStatement where:ReceiptsTable.COLUMN_REIMBURSABLE value:@(YES)];
    }
    return [self executeDecimalQuery:sumStatement usingDatabase:database];
}

+ (NSString *)extraInsertValue:(NSString *)extraValue {
    if (!extraValue) {
        return SRNoData;
    } else {
        if ([extraValue caseInsensitiveCompare:@"null"] == NSOrderedSame) {
            return @"";
        }
    }

    return extraValue;
}

- (BOOL)deleteReceiptsForTrip:(WBTrip *)trip {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self deleteReceiptsForTrip:trip usingDatabase:db];
    }];
    return result;
}

- (BOOL)deleteReceiptsForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *delete = [DatabaseQueryBuilder deleteStatementForTable:ReceiptsTable.TABLE_NAME];
    [delete where:ReceiptsTable.COLUMN_PARENT_ID value:@(trip.objectId)];
    return [self executeQuery:delete usingDatabase:database];
}

- (BOOL)moveReceiptsWithParent:(NSInteger)previous toParent:(NSInteger)next usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:ReceiptsTable.TABLE_NAME];
    [update addParam:ReceiptsTable.COLUMN_PARENT_ID value:@(next)];
    [update where:ReceiptsTable.COLUMN_PARENT_ID value:@(previous)];
    return [self executeQuery:update usingDatabase:database];
}

- (FetchedModelAdapter *)fetchedReceiptsAdapterForTrip:(WBTrip *)trip {
    DatabaseQueryBuilder *query = [WBReceipt selectAllUnmarkedForDeletion:trip];
    [query orderBy:ReceiptsTable.COLUMN_DATE ascending:YES];
    return [self createAdapterUsingQuery:query forModel:[WBReceipt class] associatedModel:trip];
}

- (BOOL)updateReceipt:(WBReceipt *)receipt changeFileNameTo:(NSString *)fileName {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:ReceiptsTable.TABLE_NAME];
    [update addParam:ReceiptsTable.COLUMN_PATH value:fileName];
    [update where:ReceiptsTable.COLUMN_ID value:@(receipt.objectId)];
    BOOL result = [self executeQuery:update];
    if (result) {
        [receipt setFilename:fileName];
        [self notifyUpdateOfModel:receipt];
    }
    return result;
}

- (BOOL)copyReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [self.filesManager copyFileForReceipt:receipt toTrip:trip];

        WBTrip *original = receipt.trip;
        [receipt setTrip:trip];
        result = [self insertReceipt:receipt usingDatabase:db];
        [receipt setTrip:original];
    }];
    return result;
}

- (BOOL)moveReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [self.filesManager moveFileForReceipt:receipt toTrip:trip];

        [self deleteReceipt:receipt usingDatabase:db];
        [receipt setTrip:trip];
        result = [self insertReceipt:receipt usingDatabase:db];
    }];
    return result;
}

- (BOOL)reorderReceipt:(WBReceipt *)receiptOne withReceipt:(WBReceipt *)receiptTwo {
    if (receiptOne.customOrderId == receiptTwo.customOrderId) {
        return YES;
    }
    
    __block BOOL result;
    
    [self.databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        result = [self reorderReceipt:receiptOne withReceipt:receiptTwo usingDatabase:db];
        *rollback = result ? NO : YES;
    }];
    
    if (result) {
        NSArray *changedModels = [self allReceiptsForTrip:receiptOne.trip];
        [self notifyReorderOfModels:changedModels];
    }
    
    return result;
}

- (BOOL)reorderReceipt:(WBReceipt *)receiptOne withReceipt:(WBReceipt *)receiptTwo usingDatabase:(FMDatabase *)database {
    BOOL isInSameDay = receiptOne.customOrderId/kDaysToOrderFactor == receiptTwo.customOrderId/kDaysToOrderFactor;
    
    if (isInSameDay) {
        BOOL isNewOrderIdGreater = receiptOne.customOrderId < receiptTwo.customOrderId;
        NSInteger newCustomOrderIdTwo = isNewOrderIdGreater ? receiptTwo.customOrderId - 1 : receiptTwo.customOrderId + 1;
        
        BOOL result = [self setCustomOrderId:receiptTwo.customOrderId forReceipt:receiptOne usingDatabase:database];
        NSString *operation = isNewOrderIdGreater ? @"-1" : @"+1";
        
        NSInteger minId = MIN(receiptOne.customOrderId, newCustomOrderIdTwo);
        NSInteger maxId = MAX(receiptOne.customOrderId, newCustomOrderIdTwo);
        
        NSArray *components = @[
                                @"UPDATE ", ReceiptsTable.TABLE_NAME,
                                [NSString stringWithFormat:@" SET %@ = %@%@ ",ReceiptsTable.COLUMN_CUSTOM_ORDER_ID, ReceiptsTable.COLUMN_CUSTOM_ORDER_ID, operation],
                                @" WHERE ", ReceiptsTable.COLUMN_CUSTOM_ORDER_ID,
                                @" BETWEEN ", @(minId).stringValue, @" AND ", @(maxId).stringValue];
        
        NSString *query = [components componentsJoinedByString:@""];
        DatabaseQueryBuilder *update = [DatabaseQueryBuilder rawQuery:query];
        result &= [self executeQuery:update usingDatabase:database];
        result &= [self setCustomOrderId:newCustomOrderIdTwo forReceipt:receiptTwo usingDatabase:database];
        return result;
    } else {
        BOOL isMoveUp = receiptTwo.customOrderId > receiptOne.customOrderId;
        NSInteger newCustomOrderId = isMoveUp ? receiptTwo.customOrderId + 1 : receiptTwo.customOrderId;
        NSString *compare = isMoveUp ? kGreaterCompare : kGreaterOrEqualCompare;
        BOOL result = [self updateOrderIdGroupOfReceipt:receiptTwo compare:compare increment:YES usingDatabase:database];
        result &= [self updateOrderIdGroupOfReceipt:receiptOne compare:compare increment:NO usingDatabase:database];
        result &= [self setCustomOrderId:newCustomOrderId forReceipt:receiptOne usingDatabase:database];
        return result;
    }
}

- (NSInteger)receiptsCountInOrderIdGroup:(NSInteger)idGroup {
    __block NSInteger result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self receiptsCountInOrderIdGroup:idGroup usingDatabase:db];
    }];
    return result;
}

- (NSInteger)receiptsCountInOrderIdGroup:(NSInteger)idGroup usingDatabase:(FMDatabase *)database {
    NSString *like = [NSString stringWithFormat:@"'%lu%%'", idGroup];
    
    
    // Selects count of receipts where custom_order_id starts with custom order id group (days).
    // For example, if custom_order_id is 17651001, group id is 17651

    NSArray *components = @[
                            @"SELECT COUNT(*) FROM ", ReceiptsTable.TABLE_NAME,
                            @" WHERE ", @"CAST(", ReceiptsTable.COLUMN_CUSTOM_ORDER_ID,  @" AS TEXT) LIKE ", like];
    
    
    NSString *query = [components componentsJoinedByString:@""];
    return [database intForQuery:query];
}


- (BOOL)updateOrderIdGroupOfReceipt:(WBReceipt *)receipt compare:(NSString *)compare increment:(BOOL)increment usingDatabase:(FMDatabase *)database {
    NSString *operation = increment ? @"+1" : @"-1";
    NSString *like = [NSString stringWithFormat:@"'%lu%%'", receipt.customOrderId/kDaysToOrderFactor];
    NSString *customOrderId = [NSString stringWithFormat:@"%lu", receipt.customOrderId];
    
    NSArray *components = @[
                            @"UPDATE ", ReceiptsTable.TABLE_NAME,
                            [NSString stringWithFormat:@" SET %@ = %@%@",ReceiptsTable.COLUMN_CUSTOM_ORDER_ID, ReceiptsTable.COLUMN_CUSTOM_ORDER_ID, operation],
                            @" WHERE ", @"CAST(", ReceiptsTable.COLUMN_CUSTOM_ORDER_ID,  @" AS TEXT) LIKE ", like,
                            @" AND ", ReceiptsTable.COLUMN_CUSTOM_ORDER_ID, compare, customOrderId];
    
    NSString *query = [components componentsJoinedByString:@""];
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder rawQuery:query];
    return [self executeQuery:update usingDatabase:database];
}

- (BOOL)setCustomOrderId:(NSInteger)customOrderId forReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:ReceiptsTable.TABLE_NAME];
    [update addParam:ReceiptsTable.COLUMN_CUSTOM_ORDER_ID value:@(customOrderId)];
    [update where:ReceiptsTable.COLUMN_ID value:@(receipt.objectId)];
    return [self executeQuery:update usingDatabase:database];
}

- (BOOL)swapReceipt:(WBReceipt *)receiptOne withReceipt:(WBReceipt *)receiptTwo {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self swapReceipt:receiptOne withReceipt:receiptTwo usingDatabase:db];
    }];

    if (result) {
        [self notifySwapOfModels:@[receiptOne, receiptTwo]];
    }

    return result;
}

- (NSInteger)customOrderIdForDate:(NSDate *)date inTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)db {
    NSInteger days = date.days;
    NSInteger custromOrderId = days * kDaysToOrderFactor + 1;
    for (NSDate *tripDate in [self datesInTrip:trip usingDatabase:db]) {
        if (tripDate.days == days) {
            custromOrderId++;
        }
    }
    return custromOrderId;
}

- (NSUInteger)nextReceiptID {
    return [self nextAutoGeneratedIDForTable:ReceiptsTable.TABLE_NAME];
}

- (BOOL)swapReceipt:(WBReceipt *)receiptOne withReceipt:(WBReceipt *)receiptTwo usingDatabase:(FMDatabase *)database {
    return [self setCustomOrderIdTo:receiptOne.customOrderId onReceipt:receiptTwo usingDatabase:database] &&
           [self setCustomOrderIdTo:receiptTwo.customOrderId onReceipt:receiptOne usingDatabase:database];
}

- (BOOL)setCustomOrderIdTo:(NSInteger)customOrderId onReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:ReceiptsTable.TABLE_NAME];
    [update addParam:ReceiptsTable.COLUMN_CUSTOM_ORDER_ID value:@(customOrderId)];
    [update where:ReceiptsTable.COLUMN_ID value:@(receipt.objectId)];
    return [self executeQuery:update usingDatabase:database];
}

- (void)appendCommonValuesFromReceipt:(WBReceipt *)receipt toQuery:(DatabaseQueryBuilder *)query {
    [query addParam:ReceiptsTable.COLUMN_PATH value:receipt.imageFileName fallback:SRNoData];
    [query addParam:ReceiptsTable.COLUMN_PARENT_ID value:@(receipt.trip.objectId)];
    [query addParam:ReceiptsTable.COLUMN_NAME value:[receipt.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [query addParam:ReceiptsTable.COLUMN_CATEGORY_ID value:@(receipt.category.objectId)];
    [query addParam:ReceiptsTable.COLUMN_COMMENT value:receipt.comment];
    [query addParam:ReceiptsTable.COLUMN_DATE value:receipt.date.milliseconds];
    [query addParam:ReceiptsTable.COLUMN_TIMEZONE value:receipt.timeZone.name];
    [query addParam:ReceiptsTable.COLUMN_REIMBURSABLE value:@(receipt.isReimbursable)];
    [query addParam:ReceiptsTable.COLUMN_ISO4217 value:receipt.price.currency.code];
    [query addParam:ReceiptsTable.COLUMN_NOTFULLPAGEIMAGE value:@(!receipt.isFullPage)];
    [query addParam:ReceiptsTable.COLUMN_PRICE value:receipt.price.amount];
    [query addParam:ReceiptsTable.COLUMN_TAX value:receipt.tax.amount];
    [query addParam:ReceiptsTable.COLUMN_EXCHANGE_RATE value:receipt.exchangeRate];
    [query addParam:ReceiptsTable.COLUMN_EXTRA_EDITTEXT_1 value:[Database extraInsertValue:receipt.extraEditText1]];
    [query addParam:ReceiptsTable.COLUMN_EXTRA_EDITTEXT_2 value:[Database extraInsertValue:receipt.extraEditText2]];
    [query addParam:ReceiptsTable.COLUMN_EXTRA_EDITTEXT_3 value:[Database extraInsertValue:receipt.extraEditText3]];
    [query addParam:ReceiptsTable.COLUMN_CUSTOM_ORDER_ID value:@(receipt.customOrderId)];
    [query addParam:ReceiptsTable.COLUMN_PAYMENT_METHOD_ID value:@(receipt.paymentMethod.objectId)];
    
    [query addParam:SyncStateColumns.LAST_LOCAL_MODIFICATION_TIME value:receipt.lastLocalModificationTime.milliseconds];
    [query addParam:SyncStateColumns.DRIVE_SYNC_IS_SYNCED value:@(receipt.isSynced)];
    [query addParam:SyncStateColumns.DRIVE_MARKED_FOR_DELETION value:@(receipt.isMarkedForDeletion)];
    [query addParam:SyncStateColumns.DRIVE_SYNC_ID value:receipt.syncId];
}

- (NSTimeInterval)maxSecondForReceiptsInTrip:(WBTrip *)trip onDate:(NSDate *)date {
    __block double result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self maxSecondForReceiptsInTrip:trip onDate:date usingDatabase:db];
    }];

    return result;
}

- (NSTimeInterval)maxSecondForReceiptsInTrip:(WBTrip *)trip onDate:(NSDate *)date usingDatabase:(FMDatabase *)database {
    NSDate *beginningOfDay = [date dateAtBeginningOfDay];
    NSString *query = @"SELECT (strftime('%s', rcpt_date / 1000, 'unixepoch') - strftime('%s', :date_start, 'unixepoch')) AS seconds FROM receipts WHERE parentKey = :parentKey AND rcpt_date / 1000  >= :date_start AND rcpt_date / 1000 < :date_end ORDER BY rcpt_date DESC LIMIT 1";
    DatabaseQueryBuilder *selectSeconds = [DatabaseQueryBuilder rawQuery:query];
    [selectSeconds addParam:@"date_start" value:@(beginningOfDay.timeIntervalSince1970)];
    [selectSeconds addParam:@"date_end" value:@([beginningOfDay dateByAddingDays:1].timeIntervalSince1970)];
    [selectSeconds addParam:@"parentKey" value:@(trip.objectId)];
    return [self executeDoubleQuery:selectSeconds usingDatabase:database];
}

- (NSArray<Currency *> *)recentCurrencies {
    NSString *rawQuery = [NSString stringWithFormat:@"SELECT %@, COUNT(*) FROM %@ GROUP BY %@ ORDER BY COUNT(*) DESC;",
                          ReceiptsTable.COLUMN_ISO4217,
                          ReceiptsTable.TABLE_NAME,
                          ReceiptsTable.COLUMN_ISO4217];
    NSMutableArray *currencies = [NSMutableArray new];
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:rawQuery];
        
        while ([resultSet next]) {
            NSString *code = [resultSet stringForColumn:ReceiptsTable.COLUMN_ISO4217];
            Currency *currency = [Currency currencyForCode:code];
            
            if (currency != nil) {
                [currencies addObject:currency];
            }
        }
    }];
    return currencies;
}

- (NSArray<NSDate *> *)datesInTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)db {
    NSMutableArray *result = [NSMutableArray new];
    NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = %lu", ReceiptsTable.COLUMN_DATE,
                       ReceiptsTable.TABLE_NAME, ReceiptsTable.COLUMN_PARENT_ID, trip.objectId];
    FMResultSet *resultSet = [db executeQuery:query];
    while ([resultSet next]) {
        NSDate *date = [NSDate dateWithMilliseconds:[resultSet longLongIntForColumn:ReceiptsTable.COLUMN_DATE]];
        [result addObject:date];
    }
    return result;
}

- (WBReceipt *)receiptByObjectID:(NSUInteger)objectID {
    __block WBReceipt *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:[WBReceipt selectByObjectID:objectID].buildStatement];
        if ([resultSet next]) {
            WBReceipt *receipt = [WBReceipt new];
            [receipt loadDataFromResultSet:resultSet];
            result = receipt;
        }
    }];
    return result;
}

- (BOOL)markAllEntriesSynced:(BOOL)synced {
    __block BOOL result;
    [self.databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        result &= [self markTable:TripsTable.TABLE_NAME synced:synced database:db];
        result &= [self markTable:ReceiptsTable.TABLE_NAME synced:synced database:db];
        result &= [self markTable:DistanceTable.TABLE_NAME synced:synced database:db];
        *rollback = !result;
    }];
    
    return result;
}

- (BOOL)markTable:(NSString *)table synced:(BOOL)synced database:(FMDatabase *)db {
    NSMutableString *query = [NSMutableString stringWithFormat:@"UPDATE %@ SET %@ = %d", table, SyncStateColumns.DRIVE_SYNC_IS_SYNCED, synced];
    if (!synced) {
        [query appendFormat:@", %@ = ''", SyncStateColumns.DRIVE_SYNC_ID];
    }
    return [db executeUpdate:query];
}

@end
