//
//  ReceiptColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumn.h"
#import "WBReceipt.h"
#import "Constants.h"
#import "ReceiptColumnBlank.h"
#import "ReceiptColumnCategoryCode.h"
#import "ReceiptColumnCategoryName.h"
#import "ReceiptColumnUserID.h"
#import "ReceiptColumnReportName.h"
#import "ReceiptColumnReportStartDate.h"
#import "ReceiptColumnReportEndDate.h"
#import "ReceiptColumnImageName.h"
#import "ReceiptColumnImagePath.h"
#import "ReceiptColumnComment.h"
#import "ReceiptColumnCurrency.h"
#import "ReceiptColumnDate.h"
#import "ReceiptColumnName.h"
#import "ReceiptColumnPictured.h"
#import "ReceiptColumnReimbursable.h"
#import "ReceiptColumnReceiptIndex.h"
#import "ReceiptUnknownColumn.h"
#import "ReceiptColumnPaymentMethod.h"
#import "ReceiptColumnReportComment.h"
#import "ReceiptColumnReportCostCenter.h"
#import "SmartReceipts-Swift.h"
#import "LocalizedString.h"

@interface LegacyResolver : NSObject
@property NSInteger type;

- (instancetype)initWithOldKey:(NSString *)oldKey newKey:(NSString *)newKey class:(Class)columnClass type:(NSInteger)type;
- (ReceiptColumn *)columnByName:(NSString *)name index:(NSInteger)index;
- (NSString *)columnName;
- (ReceiptColumn *)column;
@end

LegacyResolver *LR(NSInteger type, NSString *old, NSString *new, Class class) {
    return [[LegacyResolver alloc] initWithOldKey:old newKey:new class:class type:type];
}

// Extras have to be filled to be active.
NSString *const WBColumnNameExtraEdittext1 = @"";
NSString *const WBColumnNameExtraEdittext2 = @"";
NSString *const WBColumnNameExtraEdittext3 = @"";


static NSArray<LegacyResolver *> *_resolvers;

@implementation ReceiptColumn

+ (void)initialize {
    _resolvers = @[
           LR(0, @"original_column_item_blank_en_us_name", @"column_item_blank", ReceiptColumnBlank.class),
           LR(1, @"original_column_item_category_code_en_us_name", @"column_item_category_code", ReceiptColumnCategoryCode.class),
           LR(2, @"original_column_item_category_name_en_us_name", @"column_item_category_name", ReceiptColumnCategoryName.class),
           LR(3, @"original_column_item_user_id_en_us_name", @"column_item_user_id", ReceiptColumnUserID.class),
           LR(4, @"original_column_item_report_name_en_us_name", @"column_item_report_name", ReceiptColumnReportName.class),
           LR(5, @"original_column_item_report_start_date_en_us_name", @"column_item_report_start_date", ReceiptColumnReportStartDate.class),
           LR(6, @"original_column_item_report_end_date_en_us_name", @"column_item_report_end_date", ReceiptColumnReportEndDate.class),
           LR(7, @"original_column_item_report_comment_en_us_name", @"column_item_report_comment", ReceiptColumnReportComment.class),
           LR(8, @"original_column_item_report_cost_center_en_us_name", @"column_item_report_cost_center", ReceiptColumnReportCostCenter.class),
           LR(9, @"original_column_item_image_file_name_en_us_name", @"column_item_image_file_name", ReceiptColumnImageName.class),
           LR(10, @"original_column_item_image_path_en_us_name", @"column_item_image_path", ReceiptColumnImagePath.class),
           LR(11, @"original_column_RECEIPTMENU_FIELD_COMMENT_en_us_name", @"RECEIPTMENU_FIELD_COMMENT", ReceiptColumnComment.class),
           LR(12, @"original_column_RECEIPTMENU_FIELD_CURRENCY_en_us_name", @"RECEIPTMENU_FIELD_CURRENCY", ReceiptColumnCurrency.class),
           LR(13, @"original_column_RECEIPTMENU_FIELD_DATE_en_us_name", @"RECEIPTMENU_FIELD_DATE", ReceiptColumnDate.class),
           LR(14, @"original_column_RECEIPTMENU_FIELD_NAME_en_us_name", @"RECEIPTMENU_FIELD_NAME", ReceiptColumnName.class),
           LR(15, @"original_column_RECEIPTMENU_FIELD_PRICE_en_us_name", @"RECEIPTMENU_FIELD_PRICE", ReceiptColumnPrice.class),
           LR(16, @"original_column_item_receipt_price_minus_tax_en_us_name", @"column_item_receipt_price_minus_tax", ReceiptColumnPriceMinusTax.class),
           LR(17, @"original_column_item_converted_price_exchange_rate_en_us_name", @"column_item_converted_price_exchange_rate", ReceiptColumnExchangedPrice.class),
           LR(18, @"original_column_RECEIPTMENU_FIELD_TAX_en_us_name", @"RECEIPTMENU_FIELD_TAX", ReceiptColumnTax.class),
           LR(19, @"original_column_item_converted_tax_exchange_rate_en_us_name", @"column_item_converted_tax_exchange_rate", ReceiptColumnExchangedTax.class),
           LR(20, @"original_column_item_converted_price_plus_tax_exchange_rate_en_us_name", @"column_item_converted_price_plus_tax_exchange_rate", ReceiptColumnNetExchangedPricePlusTax.class),
           LR(21, @"original_column_item_converted_price_minus_tax_exchange_rate_en_us_name", @"column_item_converted_price_minus_tax_exchange_rate", ReceiptColumnExchangedPriceMinusTax.class),
           LR(22, @"original_column_item_exchange_rate_en_us_name", @"column_item_exchange_rate", ReceiptColumnExchangeRate.class),
           LR(23, @"original_column_item_pictured_en_us_name", @"column_item_pictured", ReceiptColumnPictured.class),
           LR(24, @"original_column_item_reimbursable_en_us_name", @"column_item_reimbursable", ReceiptColumnReimbursable.class),
           LR(24, @"original_column_item_deprecated_expensable_en_us_name", @"column_item_reimbursable", ReceiptColumnReimbursable.class),
           LR(25, @"original_column_item_index_en_us_name", @"column_item_index", ReceiptColumnReceiptIndex.class),
           LR(26, @"original_column_item_id_en_us_name", @"column_item_id", ReceiptColumnReceiptId.class),
           LR(27, @"original_column_item_payment_method_en_us_name", @"column_item_payment_method", ReceiptColumnPaymentMethod.class),
    ];
    
}

- (NSString *)valueFromRow:(id)row forCSV:(BOOL)forCVS {
    return [self valueFromReceipt:row forCSV:forCVS];
}

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    ABSTRACT_METHOD
    return nil;
}

- (NSString *)valueForFooter:(NSArray *)rows forCSV:(BOOL)forCSV {
    return @"";
}

+ (ReceiptColumn *)columnName:(NSString *)columnName {
    return [ReceiptColumn columnWithIndex:-1 name:columnName];
}

+ (ReceiptColumn *)columnType:(NSInteger)type {
    for (LegacyResolver *resolver in _resolvers) {
        if (resolver.type == type) {
            return [resolver column];
        }
    }
    
    return [ReceiptUnknownColumn new];
}

+ (ReceiptColumn *)columnType:(NSInteger)type uuid:(NSString *)uuid{
    ReceiptColumn *result;
    for (LegacyResolver *resolver in _resolvers) {
        if (resolver.type == type) {
            result = [resolver column];
            result.uuid = uuid;
            return result;
        }
    }
    
    result = [ReceiptUnknownColumn new];
    result.uuid = uuid;
    return result;
}

+ (ReceiptColumn *)columnWithIndex:(NSInteger)index name:(NSString *)columnName {
    // for compability.
    // legacy string, expensable was renamed to reimbursable
    if ([columnName isEqualToString:Localized(@"column_item_deprecated_expensable")]) {
        columnName = Localized(@"column_item_reimbursable");
    }
    
    ReceiptColumn *column;
    for (LegacyResolver *resolver in _resolvers) {
        column = [resolver columnByName:columnName index:index];
        if (column) {
            break;
        }
    }
    
    if (!column) {
        column = [ReceiptUnknownColumn new];
    }
    
    return column;
}

+ (NSArray *)availableColumnsNames {
    NSMutableArray *arr = [NSMutableArray new];
    for (LegacyResolver *resolver in _resolvers) {
        [arr addObject:resolver.columnName];
    }

    [arr sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    NSArray *optional = @[WBColumnNameExtraEdittext1, WBColumnNameExtraEdittext2, WBColumnNameExtraEdittext3];

    for (NSString *str in optional) {
        if (str.length > 0) {
            [arr addObject:str];
        }
    }

    return arr;
}

@end


//MARK: - Legacy Resolver

@interface LegacyResolver()
@property NSString *legacyKey;
@property NSString *localizedKey;
@property Class columnClass;
@end

@implementation LegacyResolver

- (instancetype)initWithOldKey:(NSString *)oldKey newKey:(NSString *)newKey class:(Class)columnClass type:(NSInteger)type {
    if (self = [super init]) {
        self.type = type;
        self.legacyKey = oldKey;
        self.localizedKey = newKey;
        self.columnClass = columnClass;
    }
    return self;
}

- (ReceiptColumn *)columnByName:(NSString *)name index:(NSInteger)index {
    NSString *localizedLegacy = Localized(self.legacyKey);
    NSString *localized = Localized(self.localizedKey);
    if ([name isEqualToString:localizedLegacy] || [name isEqualToString:localized]) {
        return [[self.columnClass alloc] initWithIndex:index type:self.type name:self.columnName];
    } else {
        for (NSString *locale in NSBundle.mainBundle.localizations) {
            NSString *path = [[NSBundle mainBundle] pathForResource:locale ofType:@"lproj"];
            if (path) {
                NSBundle *bundle = [NSBundle bundleWithPath:path];
                if (bundle) {
                    localizedLegacy = [bundle localizedStringForKey:self.legacyKey value:@"" table:nil];
                    localized = [bundle localizedStringForKey:self.localizedKey value:@"" table:nil];
                    if ([localizedLegacy isEqualToString:self.legacyKey] || [localized isEqualToString:self.localizedKey]) {
                        localizedLegacy = [bundle localizedStringForKey:self.legacyKey value:@"" table:@"SharedLocalizable"];
                        localized = [bundle localizedStringForKey:self.localizedKey value:@"" table:@"SharedLocalizable"];
                    }
                    
                    if ([name isEqualToString:localizedLegacy] || [name isEqualToString:localized]) {
                        return [[self.columnClass alloc] initWithIndex:index type:self.type name:self.columnName];
                    }
                }
            }
        }
    }
    
    return nil;
}

- (NSString *)columnName {
    return [WBPreferences localizedWithKey:self.localizedKey];
}

- (ReceiptColumn *)column {
    return [[self.columnClass alloc] initWithIndex:0 type:self.type name:self.columnName];
}

@end
