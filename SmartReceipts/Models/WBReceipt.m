//
//  WBReceipt.m
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

@import FMDB;
#import "WBReceipt.h"
#import "WBTrip.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "DatabaseTableNames.h"
#import "Constants.h"
#import "NSDate+Calculations.h"
#import "WBTextUtils.h"
#import <SmartReceipts-Swift.h>
#import "LocalizedString.h"

static NSString* checkNoData(NSString* str) {
    if ([SRNoData caseInsensitiveCompare:str] == NSOrderedSame) {
        return nil;
    }
    return str;
}

@interface WBReceipt ()

@property (nonatomic, strong) NSDate *originalDate;
@property (nonatomic, strong) NSDecimalNumber *priceAmount;
@property (nonatomic, strong) NSDecimalNumber *taxAmount;
@property (nonatomic, strong) Currency *currency;

@end

@implementation WBReceipt
{
    NSString *_fileName;
    NSString *_name;
    NSString *_extraEditText1, *_extraEditText2, *_extraEditText3;
    NSTimeZone *_timeZone;
}

- (id)initWithId:(NSUInteger)rid
            name:(NSString *)name
        category:(WBCategory *)category
   imageFileName:(NSString *)imageFileName
            date:(NSDate *)date
    timeZoneName:(NSString *)timeZoneName
         comment:(NSString *)comment
     priceAmount:(NSDecimalNumber *)price
       taxAmount:(NSDecimalNumber *)tax
    exchangeRate:(NSDecimalNumber *)exchangeRate
        currency:(Currency *)currency
   paymentMethod:(PaymentMethod *)paymentMethod
  isReimbursable:(BOOL)isReimbursable
      isFullPage:(BOOL)isFullPage
  extraEditText1:(NSString *)extraEditText1
  extraEditText2:(NSString *)extraEditText2
  extraEditText3:(NSString *)extraEditText3
   customOrderId:(NSInteger)customOrderId {
    self = [super init];
    if (self) {
        _objectId = rid;
        _name = name;
        _fileName = checkNoData([imageFileName lastPathComponent]);
        _category = category;
        _date = date;
        _originalDate = date;

        _timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
        if (!_timeZone) {
            _timeZone = [NSTimeZone localTimeZone];
        }

        _comment = comment;
        _priceAmount = price;
        _taxAmount = tax;
        _currency = currency;
        _exchangeRate = exchangeRate;
        _paymentMethod = paymentMethod;

        _reimbursable = isReimbursable;
        _fullPage = isFullPage;
        _extraEditText1 = checkNoData(extraEditText1);
        _extraEditText2 = checkNoData(extraEditText2);
        _extraEditText3 = checkNoData(extraEditText3);
        _customOrderId = customOrderId;
    }
    return self;
}

-(NSUInteger)receiptId {
    return self.objectId;
}

-(NSString*)imageFileName {
    return _fileName;
}

- (NSString *)omittedName {
    return [WBTextUtils omitIllegalCharacters:self.name];
}

-(NSTimeZone*)timeZone {
    if (_timeZone) {
        return _timeZone;
    }
    return [NSTimeZone systemTimeZone];
}

- (BOOL)dateChanged {
    return ![self.date isEqualToDate:self.originalDate];
}

- (void)setDate:(NSDate *)date {
    _date = date;

    if (!self.originalDate) {
        [self setOriginalDate:date];
    }
}

-(NSString*)extraEditText1 {
    return _extraEditText1;
}

-(NSString*)extraEditText2 {
    return _extraEditText2;
}

-(NSString*)extraEditText3 {
    return _extraEditText3;
}

- (void)setFilename:(NSString *)filename {
    _fileName = [filename lastPathComponent];
}

-(NSString*)imageFilePathForTrip:(WBTrip*)trip {
    if (!checkNoData(_fileName)) {
        return nil;
    }
    return [[trip directoryPath] stringByAppendingPathComponent:_fileName];
}

- (BOOL)hasFileForTrip:(WBTrip *)trip {
    return _fileName && ([[NSFileManager defaultManager] fileExistsAtPath:[self imageFilePathForTrip:trip]]);
}

-(BOOL)fileHasExtension:(NSArray*) possibleExtensions {
    NSString* ext = [_fileName pathExtension];
    for (NSString* pe in possibleExtensions) {
        if ([pe caseInsensitiveCompare:ext]==NSOrderedSame) {
            return true;
        }
    }
    return false;
}

- (BOOL)hasImage {
    return [self hasFileForTrip:self.trip] && [self hasImageFileName];
}

- (BOOL)hasPDF {
    return [self hasFileForTrip:self.trip] && [self hasPDFFileName];
}

-(BOOL)hasImageFileName {
    return [self fileHasExtension:@[@"jpg",@"jpeg",@"png"]];
}

-(BOOL)hasPDFFileName {
    return [self fileHasExtension:@[@"pdf"]];
}

-(BOOL)hasExtraEditText1 {
    return _extraEditText1 != nil;
}

-(BOOL)hasExtraEditText2 {
    return _extraEditText2 != nil;
}

-(BOOL)hasExtraEditText3 {
    return _extraEditText3 != nil;
}

- (void)loadDataFromResultSet:(FMResultSet *)resultSet {
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberOrZero:[resultSet stringForColumn:ReceiptsTable.COLUMN_PRICE]];
    NSDecimalNumber *tax = [NSDecimalNumber decimalNumberOrZero:[resultSet stringForColumn:ReceiptsTable.COLUMN_TAX]];
    NSDecimalNumber *exchangeRate = [NSDecimalNumber decimalNumberOrZero:[resultSet stringForColumn:ReceiptsTable.COLUMN_EXCHANGE_RATE]];
    NSString *currencyCode = [resultSet stringForColumn:ReceiptsTable.COLUMN_ISO4217];
    
    [self setObjectId:(NSUInteger) [resultSet intForColumn:ReceiptsTable.COLUMN_ID]];
    _name = [resultSet stringForColumn:ReceiptsTable.COLUMN_NAME];
    _fileName = [resultSet stringForColumn:ReceiptsTable.COLUMN_PATH];
    _comment = [resultSet stringForColumn:ReceiptsTable.COLUMN_COMMENT];
    _priceAmount = price;
    _taxAmount = tax;
    _exchangeRate = exchangeRate;
    _currency = [Currency currencyForCode:currencyCode];
    [self setReimbursable:[resultSet boolForColumn:ReceiptsTable.COLUMN_REIMBURSABLE]];
    [self setFullPage:![resultSet boolForColumn:ReceiptsTable.COLUMN_NOTFULLPAGEIMAGE]];
    _extraEditText1 = [resultSet stringForColumn:ReceiptsTable.COLUMN_EXTRA_EDITTEXT_1];
    _extraEditText2 = [resultSet stringForColumn:ReceiptsTable.COLUMN_EXTRA_EDITTEXT_2];
    _extraEditText3 = [resultSet stringForColumn:ReceiptsTable.COLUMN_EXTRA_EDITTEXT_3];
    _timeZone = [NSTimeZone timeZoneWithName:[resultSet stringForColumn:ReceiptsTable.COLUMN_TIMEZONE]];
    [self setDate:[NSDate dateWithMilliseconds:[resultSet longLongIntForColumn:ReceiptsTable.COLUMN_DATE]]];
    _customOrderId = [resultSet intForColumn:ReceiptsTable.COLUMN_CUSTOM_ORDER_ID];
    _parentKey = [resultSet intForColumn:ReceiptsTable.COLUMN_PARENT_ID];
    
    // Category
    
    NSString *categories = [NSString stringWithFormat:@"%@_", CategoriesTable.TABLE_NAME];
    NSString *categoryIdAsName = [categories stringByAppendingString:CategoriesTable.COLUMN_ID];
    NSString *categoryCodeAsName = [categories stringByAppendingString:CategoriesTable.COLUMN_CODE];
    NSString *categoryNameAsName = [categories stringByAppendingString:CategoriesTable.COLUMN_NAME];
    
    NSString *categoryCode = [resultSet stringForColumn:categoryCodeAsName];
    NSString *categoryName = [resultSet stringForColumn:categoryNameAsName];
    NSInteger categoryId = [resultSet intForColumn:categoryIdAsName];
    
    if (categoryCode && categoryName) {
        WBCategory *category = [[WBCategory alloc] initWithName:categoryName code:categoryCode customOrderId:0 objectId:categoryId];
        _category = category;
    }
    
    // Payment Method
    
    NSString *paymentMethods = [NSString stringWithFormat:@"%@_", PaymentMethodsTable.TABLE_NAME];
    NSString *paymentMethodIdAsName = [paymentMethods stringByAppendingString:PaymentMethodsTable.COLUMN_ID];
    
    NSUInteger paymentMethodId = [resultSet intForColumn:paymentMethodIdAsName];
    NSString *paymentMethodName = [resultSet stringForColumn:PaymentMethodsTable.COLUMN_METHOD];
    
    if (paymentMethodName) {
        PaymentMethod *pm = [[PaymentMethod alloc] initWithObjectId:paymentMethodId method:paymentMethodName uuid:@""];
        [self setPaymentMethod:pm];
    }
    
    long long int time = [resultSet longLongIntForColumn:SyncStateColumns.LAST_LOCAL_MODIFICATION_TIME];
    _lastLocalModificationTime = [NSDate dateWithMilliseconds:time];
    _isSynced = [resultSet boolForColumn:SyncStateColumns.DRIVE_SYNC_IS_SYNCED];
    _isMarkedForDeletion = [resultSet boolForColumn:SyncStateColumns.DRIVE_MARKED_FOR_DELETION];
    _syncId = [resultSet stringForColumn:SyncStateColumns.DRIVE_SYNC_ID];
    _uuid = [resultSet stringForColumn:CommonColumns.ENTITY_UUID];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    WBReceipt *otherReceipt = other;
    return self.objectId == otherReceipt.objectId;
}

- (NSUInteger)hash {
    return @(self.objectId).hash;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name: %@, ", self.name];
    [description appendFormat:@"date: %@", self.date];
    [description appendString:@">"];
    return description;
}

- (NSString *)attachmentMarker {
    if (self.hasImage) {
        return LocalizedString(@"image", nil);
    } else if (self.hasPDF) {
        return LocalizedString(@"pdf", nil);
    }

    return @"";
}

- (void)setPrice:(NSDecimalNumber *)amount currency:(NSString *)currency {
    self.priceAmount = amount;
    self.currency = [Currency currencyForCode:currency];
}

- (void)setTax:(NSDecimalNumber *)amount {
    self.taxAmount = amount;
}

- (PaymentMethod *)paymentMethod {
    if (!_paymentMethod) {
        _paymentMethod = [[PaymentMethod alloc] initWithObjectId:0 method:@"" uuid:@""];
    }
    return _paymentMethod;
}

- (id)copy {
    WBReceipt *copy = [[WBReceipt alloc] initWithId:self.objectId
                                               name:self.name
                                           category:self.category
                                      imageFileName:self.imageFileName
                                               date:self.date
                                       timeZoneName:self.timeZone.name
                                            comment:self.comment
                                        priceAmount:self.priceAmount
                                          taxAmount:self.taxAmount
                                       exchangeRate:self.exchangeRate
                                           currency:self.currency
                                      paymentMethod:self.paymentMethod
                                     isReimbursable:self.isReimbursable
                                         isFullPage:self.isFullPage
                                     extraEditText1:self.extraEditText1
                                     extraEditText2:self.extraEditText2
                                     extraEditText3:self.extraEditText3
                                      customOrderId:self.customOrderId];
    
    copy.isSynced = _isSynced;
    copy.lastLocalModificationTime = _lastLocalModificationTime;
    copy.syncId = _syncId;
    copy.isMarkedForDeletion = _isMarkedForDeletion;
    copy.parentKey = _parentKey;
    return copy;
}

@end
