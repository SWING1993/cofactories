//
//  SearchShopMarketModel.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/12.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchShopMarketModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *sales;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSArray *photoArray;
- (instancetype)initSearchShopModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getSearchShopModelWithDictionary:(NSDictionary *)dictionary;

@end
