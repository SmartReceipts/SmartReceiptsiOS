//
//  FetchedModelAdapter.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

@import FMDB;
#import "FetchedModelAdapter.h"
#import "Database.h"
#import "FetchedModel.h"
#import "Constants.h"
#import "FetchedModelAdapterDelegate.h"
#import "SmartReceipts-Swift.h"

@interface FetchedModelAdapter ()

@property (nonatomic, strong) Database *database;
@property (nonatomic, copy) NSString *fetchQuery;
@property (nonatomic, strong) NSDictionary *fetchParameters;
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, assign) SEL associatedSelector;

@end

@implementation FetchedModelAdapter

- (id)initWithDatabase:(Database *)database {
    self = [super init];
    if (self) {
        _database = database;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInsertObject:) name:DatabaseDidInsertModelNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteObject:) name:DatabaseDidDeleteModelNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateObject:) name:DatabaseDidUpdateModelNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSwapObjects:) name:DatabaseDidSwapModelsNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReorderObjects:) name:DatabaseDidReorderModelsNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didImportDatabase) name:SmartReceiptsDatabaseBulkUpdateNotification object:nil];
        
    }
    return self;
}

- (void)setModels:(NSArray *)models {
    _models = models;
    [self.delegate didSetModels:models];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)objectAtIndex:(NSInteger)index {
    return self.models[index];
}

- (NSUInteger)numberOfObjects {
    return self.models.count;
}

- (void)setQuery:(NSString *)query {
    [self setQuery:query parameters:@{}];
}

- (void)setQuery:(NSString *)query parameters:(NSDictionary *)parameters {
    [self setFetchQuery:query];
    [self setFetchParameters:parameters];
}

- (void)fetch {
    [self.database.databaseQueue inDatabase:^(FMDatabase *db) {
        [self fetchUsingDatabase:db];
    }];
}

- (void)fetchUsingDatabase:(FMDatabase *)database {
    NSArray<id<FetchedModel>> *objects = [self performObjectsFetchUsingDatabase:database];
    
    if (self.afterFetchHandler) {
        for (id<FetchedModel> model in objects) {
            self.afterFetchHandler(model, database);
        }
    }
    
    [self setModels:objects];
}

- (NSArray *)allObjects {
    return [NSArray arrayWithArray:self.models];
}

- (void)didInsertObject:(NSNotification *)notification {
    NSObject *inserted = notification.object;
    if (![inserted isKindOfClass:self.modelClass]) {
        return;
    }

    [self refreshContentAndNotifyInsertChanges];
}

- (void)didDeleteObject:(NSNotification *)notification {
    NSObject *deleted = notification.object;
    if (![deleted isKindOfClass:self.modelClass]) {
        return;
    }

    [self refreshContentAndNotifyDeleteChanges];
}

- (void)didUpdateObject:(NSNotification *)notification {
    NSObject *updated = notification.object;
    if (![updated isKindOfClass:self.modelClass]) {
        return;
    }

    [self refreshContentAndNotifyUpdateChanges:updated];
}

- (void)didSwapObjects:(NSNotification *)notification {
    NSArray *models = [notification object];
    if (![models.firstObject isKindOfClass:self.modelClass]) {
        return;
    }

    [self refreshContentAndNotifySwapChanges:models];
}

- (void)didReorderObjects:(NSNotification *)notification {
    NSArray *models = [notification object];
    if (![models.firstObject isKindOfClass:self.modelClass]) {
        return;
    }
    
    [self refreshContentAndNotifyReorderChanges:models];
}

- (void)refreshContentAndNotifyUpdateChanges:(NSObject *)updated {
    NSArray *before = [NSArray arrayWithArray:self.models];
    [self.database inDatabase:^(FMDatabase * _Nonnull database) {
        [self fetchUsingDatabase:database];
        
        if (self.afterFetchHandler) {
            self.afterFetchHandler((id<FetchedModel>)updated, database);
        }
    }];

    NSArray *after = [NSArray arrayWithArray:self.models];

    NSUInteger indexBefore = [before indexOfObject:updated];
    NSUInteger indexAfter = [after indexOfObject:updated];
    
    if (indexAfter == NSNotFound || indexBefore == NSNotFound) {
        [self.delegate reloadData];
        return;
    }
    
    [self.delegate willChangeContent];
    if (indexBefore == indexAfter) {
        [self.delegate didUpdateObject:updated atIndex:indexBefore];
    } else {
        [self.delegate didMoveObject:updated fromIndex:indexBefore toIndex:indexAfter];
    }
    [self.delegate didChangeContent];
}

- (void)refreshContentAndNotifyDeleteChanges {
    NSArray *previousObjectsForIndex = [NSArray arrayWithArray:self.models];
    NSMutableArray *previousObjects = [NSMutableArray arrayWithArray:self.models];

    NSArray *refreshed = [self performObjectsFetch];

    [previousObjects removeObjectsInArray:refreshed];

    id removed = [previousObjects lastObject];
    NSUInteger index = [previousObjectsForIndex indexOfObject:removed];
    
    if (index == NSNotFound) {
        [self.delegate reloadData];
        return;
    }
    
    [self.delegate willChangeContent];

    [self setModels:refreshed];
    [self.delegate didDeleteObject:removed atIndex:index];

    [self.delegate didChangeContent];
}

- (void)refreshContentAndNotifyInsertChanges {
    NSArray *previousObjects = [NSArray arrayWithArray:self.models];
    NSArray *refreshed = [self performObjectsFetch];
    NSMutableArray *currentObjects = [NSMutableArray arrayWithArray:refreshed];
    [currentObjects removeObjectsInArray:previousObjects];

    id added = [currentObjects lastObject];

    NSUInteger index = [refreshed indexOfObject:added];
    //insert was done for some other monitored adapter. Nothing here to do
    if (index == NSNotFound) {
        [self setModels:refreshed];
        return;
    }
    
    if (self.afterFetchHandler) {
        [self.database inDatabase:^(FMDatabase * _Nonnull database) {
            self.afterFetchHandler(added, database);
        }];
    }

    [self.delegate willChangeContent];

    [self setModels:refreshed];
    [self.delegate didInsertObject:added atIndex:index];

    [self.delegate didChangeContent];
}

- (void)refreshContentAndNotifySwapChanges:(NSArray *)swapped {
    [self.database.databaseQueue inDatabase:^(FMDatabase *db) {
        [self fetchUsingDatabase:db];
    }];

    [self.delegate willChangeContent];
    for (NSObject<FetchedModel> *model in swapped) {
        NSUInteger index = [self indexForObject:model];
        [self.delegate didUpdateObject:model atIndex:index];
    }
    [self.delegate didChangeContent];
}

- (void)refreshContentAndNotifyReorderChanges:(NSArray *)changed {
    [self.database.databaseQueue inDatabase:^(FMDatabase *db) {
        [self fetchUsingDatabase:db];
    }];
    
    [self.delegate willChangeContent];
    for (NSObject<FetchedModel> *model in changed) {
        NSUInteger index = [self indexForObject:model];
        [self.delegate didUpdateObject:model atIndex:index];
    }
    [self.delegate didChangeContent];
}

- (void)clearNotificationListener {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray *)performObjectsFetch {
    __block NSArray *result;
    [self.database.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self performObjectsFetchUsingDatabase:db];
    }];

    return result;
}

- (NSArray *)performObjectsFetchUsingDatabase:(FMDatabase *)database {
    TICK;
    NSMutableArray *result = [NSMutableArray array];
    LOGGER_DEBUG(@"Fetch query: '%@'", self.fetchQuery);
    LOGGER_DEBUG(@"Fetch params: %@", self.fetchParameters);

    FMResultSet *resultSet = [database executeQuery:self.fetchQuery withParameterDictionary:self.fetchParameters];
    while ([resultSet next]) {
        NSObject<FetchedModel> *fetched = (NSObject<FetchedModel> *) [[self.modelClass alloc] init];
        [fetched loadDataFromResultSet:resultSet];

        if (self.associatedModel) {
            IMP imp = [fetched methodForSelector:self.associatedSelector];
            void (*func)(id, SEL, id) = (void *)imp;
            func(fetched, self.associatedSelector, self.associatedModel);
        }

        [result addObject:fetched];
    }
    
    LOGGER_DEBUG(@"Fetch time %@", TOCK);
    
    return [NSArray arrayWithArray:result];
}

- (void)setAssociatedModel:(NSObject *)associatedModel {
    _associatedModel = associatedModel;

    if (!associatedModel) {
        return;
    }

    NSString *className = NSStringFromClass(self.associatedModel.class);
    if ([className rangeOfString:@"WB"].location == 0) {
        className = [className substringFromIndex:2];
    }
    NSString *selectorPattern = [NSString stringWithFormat:@"set%@:", className];
    [self setAssociatedSelector:NSSelectorFromString(selectorPattern)];
}


- (NSUInteger)indexForObject:(id)object {
    return [self.models indexOfObject:object];
}

- (void)didImportDatabase {
    [self fetch];
    [self.delegate reloadData];
}

@end
