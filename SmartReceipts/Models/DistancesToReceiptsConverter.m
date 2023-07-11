//
//  DistancesToReceiptsConverter.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 12/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistancesToReceiptsConverter.h"
#import "WBReceipt.h"
#import "LocalizedString.h"
#import <SmartReceipts-Swift.h>

@interface DistancesToReceiptsConverter ()

@property (nonatomic, strong) NSArray *distances;

@end

@implementation DistancesToReceiptsConverter

+ (NSArray *)convertDistances:(NSArray *)distances {
    DistancesToReceiptsConverter *converter = [[DistancesToReceiptsConverter alloc] initWithDistances:distances];
    return [converter generateReceipts];
}

- (id)initWithDistances:(NSArray *)distances {
    self = [super init];
    if (self) {
        _distances = distances;
    }
    return self;
}

- (NSArray *)generateReceipts {
    NSMutableArray *receipts = [NSMutableArray array];

    NSDictionary *grouped = [self groupReceipts];
    for (NSString *key in grouped) {
        NSArray *dayDistances = grouped[key];
        WBReceipt *receipt = [self createReceiptFromDistances:dayDistances];
        [receipts addObject:receipt];
    }

    return [NSArray arrayWithArray:receipts];
}

- (WBReceipt *)createReceiptFromDistances:(NSArray *)distances {
    Distance *distance = [distances firstObject];
    NSMutableArray *locations = [NSMutableArray array];
    for (Distance *r in distances) {
        if ([locations containsObject:r.location]) {
            continue;
        }

        [locations addObject:r.location];
    }

    NSString *name = locations.count > 0 ? [locations componentsJoinedByString:@"; "] : LocalizedString(@"distance", nil);
    NSDate *date = distance.date;
    NSTimeZone *timeZone = distance.timeZone;
    NSString *category = LocalizedString(@"distance", nil);
    NSDecimalNumber *totalPrice = [self totalPriceForDistances:distances];

    WBReceipt *receipt = [[WBReceipt alloc] initWithId:0
                                    name:name
                                category:[Database.sharedInstance categoryByName:category]
                           imageFileName:nil
                                    date:date
                            timeZoneName:timeZone.name
                                 comment:nil
                             priceAmount:totalPrice
                               taxAmount:[NSDecimalNumber zero]
                            exchangeRate:[NSDecimalNumber zero]
                                currency:distance.rate.currency
                           paymentMethod:nil
                          isReimbursable:YES
                              isFullPage:NO
                          extraEditText1:@""
                          extraEditText2:@""
                          extraEditText3:@""
                          customOrderId:date.timeIntervalSince1970];
    [receipt setTrip:distance.trip];

    return receipt;
}

- (NSDecimalNumber *)totalPriceForDistances:(NSArray *)distances {
    NSDecimalNumber *result = [NSDecimalNumber zero];
    for (Distance *distance in distances) {
        result = [result decimalNumberByAdding:distance.totalRate.amount];
    }
    return result;
}

- (NSDictionary *)groupReceipts {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableDictionary *grouped = [NSMutableDictionary dictionary];
    for (Distance *distance in self.distances) {
        NSString *formattedDate = [formatter stringFromDate:distance.date];
        NSMutableArray *dayDistances = grouped[formattedDate];
        if (!dayDistances) {
            dayDistances = [NSMutableArray array];
            grouped[formattedDate] = dayDistances;
        }

        [dayDistances addObject:distance];
    }
    return [NSDictionary dictionaryWithDictionary:grouped];
}

@end
