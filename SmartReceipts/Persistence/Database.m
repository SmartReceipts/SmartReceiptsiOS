//
//  Database.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import "Database.h"
#import "Constants.h"
#import "DatabaseMigration.h"
#import "ReceiptFilesManager.h"
#import "WBPreferences.h"
#import "Database+Trips.h"

NSString *const DatabaseDidInsertModelNotification = @"DatabaseDidInsertModelNotification";
NSString *const DatabaseDidDeleteModelNotification = @"DatabaseDidDeleteModelNotification";
NSString *const DatabaseDidUpdateModelNotification = @"DatabaseDidUpdateModelNotification";
NSString *const DatabaseDidSwapModelsNotification = @"DatabaseDidSwapModelsNotification";
NSString *const DatabaseDidReorderModelsNotification = @"DatabaseDidReorderModelsNotification";

@interface Database ()

@property (nonatomic, copy) NSString *pathToDatabase;
@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;
@property (nonatomic, strong) ReceiptFilesManager *filesManager;
@property (nonatomic, assign) BOOL disableFilesManager;
@property (nonatomic, assign) BOOL disableNotifications;

@property (nonatomic, assign) BOOL lastKnownAddDistancePriceToReportValue;
@property (nonatomic, assign) BOOL lastKnownOnlyReportReimbursableValue;

@end

@implementation Database

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initSingleton];
    });
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedInstance))]
                                 userInfo:nil];
    return nil;
}

- (id)initSingleton {
    return [self initWithDatabasePath:[NSFileManager pathInDocumentsWithRelativePath:SmartReceiptsDatabaseName]
                      tripsFolderPath:[NSFileManager tripsDirectoryPath]];
}

- (id)initWithDatabasePath:(NSString *)path tripsFolderPath:(NSString *)tripsFolderPath {
    self = [super init];
    if (self) {
        _pathToDatabase = path;
        _filesManager = [[ReceiptFilesManager alloc] initWithTripsFolder:tripsFolderPath];

        [self markKnownValues];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTripPrices) name:SmartReceiptsSettingsSavedNotification object:nil];
    }
    return self;
}

- (BOOL)open {
    return [self open:YES];
}

- (BOOL)open:(BOOL)migrateDatabase {
    FMDatabaseQueue *db = [FMDatabaseQueue databaseQueueWithPath:self.pathToDatabase];

    if (!db) {
        return NO;
    }

    [self setDatabaseQueue:db];

    if (!migrateDatabase) {
        return YES;
    }

    return [DatabaseMigration migrateDatabase:self];
}

- (void)close {
    [self.databaseQueue close];
}

- (ReceiptFilesManager *)filesManager {
    if (self.disableFilesManager) {
        return nil;
    }

    return _filesManager;
}

- (void)refreshTripPrices {
    if (![self knownPriceRelatedValuesHaveChanged]) {
        return;
    }

    [self markKnownValues];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SmartReceiptsDatabaseBulkUpdateNotification object:nil];
    });
}

- (BOOL)knownPriceRelatedValuesHaveChanged {
    return self.lastKnownAddDistancePriceToReportValue != [WBPreferences isTheDistancePriceBeIncludedInReports]
            || self.lastKnownOnlyReportReimbursableValue != [WBPreferences onlyIncludeReimbursableReceiptsInReports];
}

- (void)markKnownValues {
    self.lastKnownAddDistancePriceToReportValue = [WBPreferences isTheDistancePriceBeIncludedInReports];
    self.lastKnownOnlyReportReimbursableValue = [WBPreferences onlyIncludeReimbursableReceiptsInReports];
}

@end
