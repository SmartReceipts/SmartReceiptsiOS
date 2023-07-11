//
//  Database+Import.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database+Import.h"
#import "Database+Trips.h"
#import "WBTrip.h"
#import "Database+Receipts.h"
#import "WBReceipt.h"
#import "Database+Distances.h"
#import "Constants.h"
#import "Database+PaymentMethods.h"
#import "Database+Categories.h"
#import "WBCategory.h"
#import "Database+PDFColumns.h"
#import "Database+CSVColumns.h"
#import <SmartReceipts-Swift.h>

@interface Distance (Expose)

@property (nonatomic, assign) NSUInteger objectId;

@end

@interface Database(InitExpose)

- (id)initWithDatabasePath:(NSString *)path tripsFolderPath:(NSString *)tripsFolderPath;
- (void)setDisableFilesManager:(BOOL)disable;
- (WBTrip *)tripWithName:(NSString *)name;

@property (nonatomic, assign) BOOL disableNotifications;

@end

@implementation Database (Import)

static NSInteger paymentMethodOffset;
static NSInteger categoryOffset;

- (BOOL)importDataFromBackup:(NSString *)filePath overwrite:(BOOL)overwrite {
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return NO;
    }

    Database *imported = [[Database alloc] initWithDatabasePath:filePath tripsFolderPath:[NSFileManager documentsPath]];
    [imported open];

    return [self importDataFromDatabase:imported overwrite:overwrite];
}

- (BOOL)importDataFromDatabase:(Database *)imported overwrite:(BOOL)overwrite {
    [self setDisableFilesManager:YES];
    [self setDisableNotifications:YES];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"objectId" ascending:YES];
    categoryOffset = [Database.sharedInstance.listAllCategories sortedArrayUsingDescriptors:@[sortDescriptor]].lastObject.objectId + 1;
    
    if (overwrite) {
        for (WBTrip *trip in Database.sharedInstance.allTrips) {
            [Database.sharedInstance deleteTrip:trip];
        }
    }
    
    [self importCategoriesFrom:imported overwrite:overwrite];
    
    // Note: these 3 always overwrite to avoid data inconsistencies
    [self importCSVColumnsFrom:imported];
    [self importPDFColumnsFrom:imported];
    [self importPaymentMethodsFrom:imported];
    
    NSArray *importedTrips = [imported allTrips];
    for (WBTrip *trip in importedTrips) {
        [self importTrip:trip importFrom:imported overwrite:overwrite];
    }
    
    [self setDisableFilesManager:NO];
    [self setDisableNotifications:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SmartReceiptsDatabaseBulkUpdateNotification object:nil];
    });
    
    return YES;
}

- (void)importTrip:(WBTrip *)trip importFrom:(Database *)importFrom overwrite:(BOOL)overwrite {
    WBTrip *existing = [self tripWithName:trip.name];
    if (existing && !overwrite) {
        return;
    }

    if (existing) {
        [self deleteTrip:existing];
    }

    [self saveTrip:trip];
    existing = [self tripWithName:trip.name];

    NSArray *receipts = [importFrom allReceiptsForTrip:trip];
    for (WBReceipt *receipt in receipts) {
        if (!receipt.isMarkedForDeletion) {
            [receipt setObjectId:0];
            [receipt setIsSynced:false];
            [receipt setTrip:existing];
            [self saveReceipt:receipt];
        }
    }

    NSArray *distances = [importFrom allDistancesForTrip:trip];
    for (Distance *distance in distances) {
        [distance setObjectId:0];
        [distance setTrip:existing];
        [self saveDistance:distance];
    }
}

- (void)importPDFColumnsFrom:(Database *)database {
    NSArray *columns = [database allPDFColumns];
    [self replaceAllPDFColumnsWith:columns];
}

- (void)importCSVColumnsFrom:(Database *)database {
    NSArray *columns = [database allCSVColumns];
    [self replaceAllCSVColumnsWith:columns];
}

- (void)importPaymentMethodsFrom:(Database *)database {
    // We have to delete all existing ones to avoid "keying" issues due to auto-increment ids
    NSArray *existing = [self allPaymentMethods];
    for (PaymentMethod *existingMethod in existing) {
        [self deletePaymentMethod:existingMethod];
    }
    
    NSArray *imported = [database allPaymentMethods];
    for (PaymentMethod *method in imported) {
        [self savePaymentMethod:method];
    }
}

- (void)importCategoriesFrom:(Database *)database overwrite:(BOOL)overwrite {
    // Since we don't have a foreign table for categories, we can handle overwrites here
    NSArray *existing = [self listAllCategories];
    NSMutableArray *existingIds = [NSMutableArray new];
    
    for (WBCategory *category in existing) {
        [existingIds addObject:@(category.objectId)];
    }
    
    if (overwrite) {
        for (WBCategory *existingCategory in existing) {
            [self deleteCategory:existingCategory];
        }
        
        existing = @[];
        [existingIds removeAllObjects];
    }
    
    NSArray *imported = [database listAllCategories];
    
    for (WBCategory *category in imported) {
        if ([existing containsObject:category]) {
            continue;
        }
        
        if ([existingIds containsObject:@(category.objectId)]) {
            category.objectId = 0;
            category.customOrderId = self.nextCustomOrderIdForCategory;
        }

        [self saveCategory:category];
    }
}

@end
