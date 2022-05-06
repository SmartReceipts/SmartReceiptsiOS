//
//  Database.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
@import FMDB;

@class ReceiptFilesManager;

extern NSString * _Nonnull const DatabaseDidInsertModelNotification;
extern NSString * _Nonnull const DatabaseDidDeleteModelNotification;
extern NSString * _Nonnull const DatabaseDidUpdateModelNotification;
extern NSString * _Nonnull const DatabaseDidSwapModelsNotification;
extern NSString * _Nonnull const DatabaseDidReorderModelsNotification;

@interface Database : NSObject

@property (nonatomic, strong, readonly) FMDatabaseQueue * _Nonnull databaseQueue;
@property (nonatomic, strong, readonly) ReceiptFilesManager * _Nonnull filesManager;
@property (nonatomic, readonly) FMDatabase * _Nonnull fmdb;
@property (nonatomic, readonly) NSString * _Nonnull pathToDatabase;


+ (_Nonnull instancetype)sharedInstance;

- (BOOL)open;
- (void)close;

@end

@interface Database (ExposeForTests)

- (_Nonnull id)initWithDatabasePath:(NSString * _Nonnull)path tripsFolderPath:(NSString * _Nonnull)tripsFolderPath;
- (BOOL)open:(BOOL)migrateDatabase;

@end
