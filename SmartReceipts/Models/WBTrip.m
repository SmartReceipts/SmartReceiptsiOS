//
//  WBTrip.m
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

@import FMDB;
#import "WBTrip.h"
#import "DatabaseTableNames.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "NSDate+Calculations.h"
#import "NSString+Validation.h"
#import "WBPreferences.h"
#import "SmartReceipts-Swift.h"

@interface WBTrip ()

@property (nonatomic, copy) NSString *originalName;

@end

@implementation WBTrip {
    float _miles;
}

- (id)init {
    self = [super init];
    if (self) {
        _startTimeZone = [NSTimeZone localTimeZone];
        _endTimeZone = [NSTimeZone localTimeZone];
    }

    return self;
}

- (NSString *)directoryPath {
    return [self directoryPathUsingName:self.name];
}

- (NSString *)directoryPathUsingName:(NSString *)name {
    return [[NSFileManager tripsDirectoryPath] stringByAppendingPathComponent:name];
}

- (NSString *)fileInDirectoryPath:(NSString *)filename {
    return [[self directoryPath] stringByAppendingPathComponent:filename];
}

- (void)setName:(NSString *)name {
    _name = name;
    
    if (self.originalName.hasValue) {
        return;
    }

    [self setOriginalName:_name];
}

- (float)miles {
    return _miles;
}

- (void)setMileage:(float)mileage {
    if (mileage < 0) {
        mileage = 0;
    }
    _miles = mileage;
}

- (BOOL)createDirectoryIfNotExists {
    NSString *dir = [self directoryPath];

    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        NSError *error;
        if ([[NSFileManager defaultManager] createDirectoryAtPath:dir
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error]) {
            return true;
        } else {
            return false;
        }
    }
    return true;
}

- (NSString *)formattedPrice {
    if (self.pricesSummary == nil) {
        self.pricesSummary = [[PricesCollection alloc] initWithCurrencyCode:self.defaultCurrency.code];
    }
    return [self.pricesSummary currencyFormattedTotalPriceWithIgnoreEmpty:NO];
}

- (BOOL)dateOutsideTripBounds:(NSDate *)date {
    return [date isBeforeDate:self.startDate] || [date isAfterDate:self.endDate];
}

- (void)loadDataFromResultSet:(FMResultSet *)resultSet {
    [self setName:[resultSet stringForColumn:TripsTable.COLUMN_NAME]];

    NSString *currencyCode = [resultSet stringForColumn:TripsTable.COLUMN_DEFAULT_CURRENCY];
    if (!currencyCode.hasValue) {
        currencyCode = [WBPreferences defaultCurrency];
    }
    self.defaultCurrency = [Currency currencyForCode:currencyCode];
    long long int startDateMilliseconds = [resultSet longLongIntForColumn:TripsTable.COLUMN_FROM];
    _startDate = [NSDate dateWithMilliseconds:startDateMilliseconds];
    _startTimeZone = [NSTimeZone timeZoneWithName:[resultSet stringForColumn:TripsTable.COLUMN_FROM_TIMEZONE]];
    long long int endDateMilliseconds = [resultSet longLongIntForColumn:TripsTable.COLUMN_TO];
    _endDate = [NSDate dateWithMilliseconds:endDateMilliseconds];
    _endTimeZone = [NSTimeZone timeZoneWithName:[resultSet stringForColumn:TripsTable.COLUMN_TO_TIMEZONE]];
    self.comment = [resultSet stringForColumn:TripsTable.COLUMN_COMMENT];
    self.costCenter = [resultSet stringForColumn:TripsTable.COLUMN_COST_CENTER];
    
    long long int time = [resultSet longLongIntForColumn:SyncStateColumns.LAST_LOCAL_MODIFICATION_TIME];
    _lastLocalModificationTime = [NSDate dateWithMilliseconds:time];
    _objectId = [resultSet intForColumn:TripsTable.COLUMN_ID];
    _uuid = [resultSet stringForColumn:CommonColumns.ENTITY_UUID];
}

- (BOOL)nameChanged {
    return [self.name compare:self.originalName] != NSOrderedSame;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name: %@, ", self.name];
    [description appendFormat:@"startDate: %@", self.startDate];
    [description appendString:@">"];
    return description;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    WBTrip *otherTrip = other;
    return [self.name isEqualToString:otherTrip.name];
}

- (NSUInteger)hash {
    return [self.name hash];
}

- (id)copy {
    WBTrip *copy = [WBTrip new];
    copy.objectId = self.objectId;
    copy.name = self.name;
    copy.originalName = self.originalName;
    copy.startDate = self.startDate;
    copy.startTimeZone = self.startTimeZone;
    copy.endDate = self.endDate;
    copy.endTimeZone = self.endTimeZone;
    copy.defaultCurrency = self.defaultCurrency;
    copy.costCenter = self.costCenter;
    copy.pricesSummary = self.pricesSummary;
    copy.comment = self.comment;
    copy.lastLocalModificationTime = self.lastLocalModificationTime;
    return copy;
}

@end


