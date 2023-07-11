//
//  DatabaseQueryBuilder.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DatabaseQueryBuilder.h"
#import "Constants.h"
#import <SmartReceipts-Swift.h>
#import "LoggerMacros-ObjC.h"

typedef NS_ENUM(short, StatementType) {
    InsertStatement = 1,
    UpdateStatement = 2,
    DeleteStatement = 3,
    SumStatement = 4,
    SelectAllStatement = 5,
    RawQuery = 6,
};

@interface DatabaseQueryBuilder ()

@property (nonatomic, assign) StatementType statement;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, strong) NSMutableDictionary *as;
@property (nonatomic, strong) NSMutableArray *params;
@property (nonatomic, strong) NSMutableArray *values;
@property (nonatomic, strong) NSMutableDictionary *where;
@property (nonatomic, strong) NSMutableArray *leftJoins;
@property (nonatomic, strong) NSDictionary *orderBy;
@property (nonatomic, strong) NSMutableArray *caseInsensitiveWhereParams;
@property (nonatomic, copy) NSString *rawQuery;
@property (nonatomic) BOOL caseInsensitiveOrder;

@end

@implementation DatabaseQueryBuilder

- (id)initStatementForTable:(NSString *)tableName statementType:(StatementType)statementType {
    self = [super init];
    if (self) {
        _statement = statementType;
        _tableName = tableName;
        _as = [NSMutableDictionary dictionary];
        _params = [NSMutableArray array];
        _values = [NSMutableArray array];
        _where = [NSMutableDictionary dictionary];
        _leftJoins = [NSMutableArray array];
        _caseInsensitiveWhereParams = [NSMutableArray array];
    }
    return self;
}

+ (DatabaseQueryBuilder *)insertStatementForTable:(NSString *)tableName {
    return [[DatabaseQueryBuilder alloc] initStatementForTable:tableName statementType:InsertStatement];
}

+ (DatabaseQueryBuilder *)deleteStatementForTable:(NSString *)tableName {
    return [[DatabaseQueryBuilder alloc] initStatementForTable:tableName statementType:DeleteStatement];
}

+ (DatabaseQueryBuilder *)updateStatementForTable:(NSString *)tableName {
    return [[DatabaseQueryBuilder alloc] initStatementForTable:tableName statementType:UpdateStatement];
}


+ (DatabaseQueryBuilder *)sumStatementForTable:(NSString *)tableName {
    return [[DatabaseQueryBuilder alloc] initStatementForTable:tableName statementType:SumStatement];
}

+ (DatabaseQueryBuilder *)selectAllStatementForTable:(NSString *)tableName {
    return [[DatabaseQueryBuilder alloc] initStatementForTable:tableName statementType:SelectAllStatement];
}

- (void)select:(NSString *)paramName as:(NSString *)otherParamName {
    self.as[paramName] = otherParamName;
}

- (void)addParam:(NSString *)paramName value:(NSObject *)paramValue {
    if (!paramValue) {
        return;
    }
    [self.params addObject:paramName];
    [self.values addObject:paramValue];
}

+ (DatabaseQueryBuilder *)rawQuery:(NSString *)rawQuery {
    DatabaseQueryBuilder *builder = [[DatabaseQueryBuilder alloc] initStatementForTable:@"" statementType:RawQuery];
    [builder setRawQuery:rawQuery];
    return builder;
}

- (void)addParam:(NSString *)paramName value:(NSObject *)paramValue fallback:(NSObject *)valueFallback {
    NSObject *value = paramValue ? paramValue : valueFallback;
    [self addParam:paramName value:value];
}

- (void)where:(NSString *)paramName value:(NSObject *)paramValue {
    [self where:paramName value:paramValue caseInsensitive:NO];
}

- (void)where:(NSString *)paramName notValue:(NSObject *)paramValue {
    [self where:[NSString stringWithFormat:@"!%@", paramName] value:paramValue];
}

- (void)where:(NSString *)paramName value:(NSObject *)paramValue caseInsensitive:(BOOL)caseInsensitive {
    self.where[paramName] = paramValue;
    if (caseInsensitive) {
        [self.caseInsensitiveWhereParams addObject:paramName];
    }
}

- (NSString *)buildStatement {
    if (self.statement == RawQuery) {
        return self.rawQuery;
    }

    NSMutableString *query = [NSMutableString string];
    if (self.statement == InsertStatement) {
        [query appendString:@"INSERT INTO "];
    } else if (self.statement == DeleteStatement) {
        [query appendString:@"DELETE FROM "];
    } else if (self.statement == UpdateStatement) {
        [query appendString:@"UPDATE "];
    } else if (self.statement == SumStatement) {
        [query appendFormat:@"SELECT SUM(%@) FROM ", self.sumColumn];
    } else if (self.statement == SelectAllStatement) {
        [query appendString:@"SELECT *"];
        [self appendSelectAs:query];
        [query appendString:@" FROM "];
    }

    [query appendString:self.tableName];

    if (self.statement == InsertStatement) {
        [self appendInsertValues:query];
    } else if (self.statement == DeleteStatement) {
        [self appendWhereClause:query];
    } else if (self.statement == UpdateStatement) {
        [self appendUpdateValues:query];
    } else if (self.statement == SumStatement || self.statement == SelectAllStatement) {
        [self appendJoinClause:query];
        [self appendWhereClause:query];
    }

    if (self.orderBy) {
        [self appendOrderBy:query];
    }
    
    return [NSString stringWithString:query];
}

-(void)appendSelectAs:(NSMutableString *)query {
    if (self.as.count == 0) {
        return;
    }
    
    for (NSString* key in self.as) {
        NSString *value = [self.as objectForKey:key];
        [query appendFormat:@", %@ AS %@", key, value];
    }
}

- (void)appendOrderBy:(NSMutableString *)query {
    NSString *key = self.orderBy.keyEnumerator.allObjects.firstObject;
    BOOL ascending = [self.orderBy[key] boolValue];
    [query appendFormat:@" ORDER BY %@",key];
    [query appendFormat:self.caseInsensitiveOrder ? @" COLLATE NOCASE" : @""];
    [query appendFormat:@" %@", ascending ? @"ASC" : @"DESC"];
}

- (void)appendJoinClause:(NSMutableString *)query {
    for (NSArray *tuple in self.leftJoins) {
        [query appendFormat:@" LEFT JOIN %@ ON %@.%@ = %@.%@", tuple[0], self.tableName, tuple[1], tuple[0], tuple[2]];
    }
}

- (void)appendWhereClause:(NSMutableString *)query {
    if (self.where.count == 0) {
        return;
    }

    [query appendString:@" WHERE "];

    NSArray *keys = self.where.keyEnumerator.allObjects;
    //sorted only for unit tests
    keys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *whereParams = [NSMutableArray array];
    for (NSString *whereKey in keys) {
        NSString *paramString;
        if ([whereKey rangeOfString:@"!"].location == 0) {
            NSString *key = [whereKey substringFromIndex:1];
            paramString = [NSString stringWithFormat:@"%@ != :w%@", key, key];
        } else {
            paramString = [NSString stringWithFormat:@"%@ = :w%@", whereKey, whereKey];
        }

        if ([self.caseInsensitiveWhereParams containsObject:whereKey]) {
            paramString = [paramString stringByAppendingString:@" COLLATE NOCASE"];
        }
        [whereParams addObject:paramString];
    }
    [query appendString:[whereParams componentsJoinedByString:@" AND "]];
}

- (void)appendUpdateValues:(NSMutableString *)query {
    [query appendString:@" SET "];
    NSMutableArray *valuesSet = [NSMutableArray array];
    for (NSString *param in self.params) {
        [valuesSet addObject:[NSString stringWithFormat:@"%@ = :%@", param, param]];
    }
    [query appendString:[valuesSet componentsJoinedByString:@", "]];
    [self appendWhereClause:query];
}

- (void)appendInsertValues:(NSMutableString *)query {
    [query appendString:@" ("];

    NSMutableString *columnsString = [NSMutableString string];
    for (NSString *name in self.params) {
        if ([columnsString length] > 0) {
            [columnsString appendString:@", "];
        }
        [columnsString appendString:name];
    }
    [query appendString:columnsString];

    [query appendString:@") VALUES ("];

    NSMutableString *valuesString = [NSMutableString string];
    for (NSString *name in self.params) {
        if ([valuesString length] > 0) {
            [valuesString appendString:@", "];
        }
        [valuesString appendFormat:@":%@", name];
    }
    [query appendString:valuesString];
    [query appendString:@")"];
}

- (NSDictionary *)parameters {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSUInteger index = 0; index < self.params.count; index++) {
        NSString *key = self.params[index];
        id value = self.values[index];
        result[key] = value;
    }
    for (NSString *whereKey in self.where) {
        NSString *key = whereKey;
        if ([key rangeOfString:@"!"].location == 0) {
            key = [key substringFromIndex:1];
        }
        result[[NSString stringWithFormat:@"w%@", key]] = self.where[whereKey];
    }
    return [NSDictionary dictionaryWithDictionary:result];
}

- (void)leftJoin:(NSString *)foreignTableName on:(NSObject *)key equalTo:(NSObject *)foreignKey {
    /* 
     * Our join array will contain a list of "tuples" in the form of array, where:
     * [0] => tableName
     * [1] => param
     * [2] => onTableParam
     * such that we can treat the statement as
     * JOIN tuple[0] ON TABLE_NAME.tuple[1] = tuple[0].tuple[2]
     */
    NSArray *joinTuple = @[foreignTableName, key, foreignKey];
    [self.leftJoins addObject:joinTuple];
}

- (void)orderBy:(NSString *)column ascending:(BOOL)ascending {
    [self orderBy:column ascending:ascending caseInsensitive:NO];
}

- (void)caseInsensitiveOrderBy:(NSString *)column ascending:(BOOL)ascending {
    [self orderBy:column ascending:ascending caseInsensitive:YES];
}

- (void)orderBy:(NSString *)column ascending:(BOOL)ascending caseInsensitive:(BOOL)caseInsensitive {
    WBAssertLoggable(!self.orderBy);
    self.orderBy = @{column : @(ascending)};
    self.caseInsensitiveOrder = caseInsensitive;
}

@end
