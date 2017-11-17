//
//  Constants.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 22/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Constants.h"

NSString *const SmartReceiptsDatabaseName = @"receipts.db";
NSString *const SmartReceiptsTripsDirectoryName = @"Trips";
NSString *const SmartReceiptsExportName = @"SmartReceipts.SMR";
NSString *const SmartReceiptsDatabaseExportName = @"receipts_backup.db";
NSString *const SmartReceiptsPreferencesExportName = @"shared_prefs/SmartReceiptsPrefFile.xml";
NSString *const SmartReceiptsPreferencesImportedNotification = @"SmartReceiptsPreferencesImportedNotification";
NSString *const SmartReceiptsDatabaseBulkUpdateNotification = @"SmartReceiptsDatabaseBulkUpdateNotification";
NSString *const SmartReceiptsSettingsSavedNotification = @"SmartReceiptsSettingsSavedNotification";
NSString *const SmartReceiptsAdsRemovedNotification = @"SmartReceiptsAdsRemovedNotification";

NSString *const SmartReceiptAppStoreId = @"905698613";

NSString *const SmartReceiptSubscriptionIAPIdentifier = @"ios_plus_sku_2";

NSString *const SRNoData = @"null";

void SRDelayedExecution(NSTimeInterval seconds, ActionBlock action) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), action);
}

NSString *const FeedbackEmailAddress =              @"will.r.baum" @"ann@gm" @"ail.com";
NSString *const FeedbackEmailSubject =              @"Smart Receipts - Feedback";
NSString *const FeedbackBugreportEmailSubject =     @"Smart Receipts - Support";
