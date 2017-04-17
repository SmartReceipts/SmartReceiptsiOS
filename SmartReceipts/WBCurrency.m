//
//  WBCurrency.m
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBCurrency.h"

@interface WBCurrency ()

@property (readwrite, nonatomic, copy) NSString *code;

@end

@implementation WBCurrency

+(NSArray*) iso4217CurrencyCodes {
    return @[
             @"AED",  @"AFN",  @"ALL",  @"AMD",  @"ANG",  @"AOA",  @"ARS",  @"AUD",  @"AWG",  @"AZN",  @"BAM",  @"BBD",  @"BDT",  @"BGN",  @"BHD",  @"BIF",  @"BMD",  @"BND",  @"BOB",  @"BOV",  @"BRL",  @"BSD",  @"BTN",  @"BWP",  @"BYR",  @"BZD",  @"CAD",  @"CDF",  @"CHE",  @"CHF",  @"CHW",  @"CLF",  @"CLP",  @"CNY",  @"COP",  @"COU",  @"CRC",  @"CUC",  @"CUP",  @"CVE",  @"CZK",  @"DJF",  @"DKK",  @"DOP",  @"DZD",  @"EGP",  @"ERN",  @"ETB",  @"EUR",  @"FJD",  @"FKP",  @"GBP",  @"GEL",  @"GHS",  @"GIP",  @"GMD",  @"GNF",  @"GTQ",  @"GYD",  @"HKD",  @"HNL",  @"HRK",  @"HTG",  @"HUF",  @"IDR",  @"ILS",  @"INR",  @"IQD",  @"IRR",  @"ISK",  @"JMD",  @"JOD",  @"JPY",  @"KES",  @"KGS",  @"KHR",  @"KMF",  @"KPW",  @"KRW",  @"KWD",  @"KYD",  @"KZT",  @"LAK",  @"LBP",  @"LKR",  @"LRD",  @"LSL",  @"LTL",  @"LVL",  @"LYD",  @"MAD",  @"MDL",  @"MGA",  @"MKD",  @"MMK",  @"MNT",  @"MOP",  @"MRO",  @"MUR",  @"MVR",  @"MWK",  @"MXN",  @"MXV",  @"MYR",  @"MZN",  @"NAD",  @"NGN",  @"NIO",  @"NOK",  @"NPR",  @"NZD",  @"OMR",  @"PAB",  @"PEN",  @"PGK",  @"PHP",  @"PKR",  @"PLN",  @"PYG",  @"QAR",  @"RON",  @"RSD",  @"RUB",  @"RWF",  @"SAR",  @"SBD",  @"SCR",  @"SDG",  @"SEK",  @"SGD",  @"SHP",  @"SLL",  @"SOS",  @"SRD",  @"SSP",  @"STD",  @"SYP",  @"SZL",  @"THB",  @"TJS",  @"TMT",  @"TND",  @"TOP",  @"TRY",  @"TTD",  @"TWD",  @"TZS",  @"UAH",  @"UGX",  @"USD",  @"USN",  @"USS",  @"UYI",  @"UYU",  @"UZS",  @"VEF",  @"VND",  @"VUV",  @"WST",  @"XAF",  @"XAG",  @"XAU",  @"XBA",  @"XBB",  @"XBC",  @"XBD",  @"XCD",  @"XDR",  @"XFU",  @"XOF",  @"XPD",  @"XPF",  @"XPT",  @"XTS",  @"XXX",  @"YER",  @"ZAR",  @"ZMW",  @"ZWL",
             ];
}

+(NSArray*) nonIso4217CurrencyCodes {
    return @[
             @"BSF",  @"DRC",  @"GHS",  @"GST",  @"XOF",  @"ZMK",  @"ZWD",
             ];
}

+(NSArray*) allCurrencyCodes {
    return [[[WBCurrency iso4217CurrencyCodes] arrayByAddingObjectsFromArray:[WBCurrency nonIso4217CurrencyCodes]]
    sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

+(WBCurrency*) currencyForCode:(NSString*) currencyCode {
    return [[WBCurrency alloc] initWithCode:currencyCode];
}

- (id)initWithCode:(NSString*)currencyCode {
    self = [super init];
    if (self) {
        self.code = currencyCode;
    }
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![other isKindOfClass:[WBCurrency class]]) {
        return NO;
    } else {
        WBCurrency *otherCurrency = other;
        return [self.code isEqualToString:otherCurrency.code];
    }
}

- (NSUInteger)hash {
    return self.code.hash;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.code forKey:@"code"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.code = [aDecoder decodeObjectForKey:@"code"];
    }
    
    return self;
}

@end
