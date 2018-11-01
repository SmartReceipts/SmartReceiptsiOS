//
//  FetchedModel.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

@class FMResultSet;

@protocol FetchedModel <NSObject>
@property (nonatomic, readonly) NSString *uuid;
- (instancetype)init;
- (void)loadDataFromResultSet:(FMResultSet *)resultSet;


@end
