//
//  SearchShopMarketModel.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/12.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "SearchShopMarketModel.h"

@implementation SearchShopMarketModel
- (instancetype)initSearchShopModelWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {

        self.ID = [NSString stringWithFormat:@"%@", dictionary[@"id"]];
        self.name = dictionary[@"name"];
        self.sales = [NSString stringWithFormat:@"%@", dictionary[@"sales"]];
        self.price = [NSString stringWithFormat:@"%.2f", [dictionary[@"price"] floatValue]];
        if ([[NSString stringWithFormat:@"%@", dictionary[@"user"][@"city"]] isEqualToString:@"<null>"]){
            self.city = @"暂未填写";
        } else {
            self.city = dictionary[@"user"][@"city"];
        }
        
        self.photoArray = dictionary[@"photo"];
        
    }
    return self;
}

+ (instancetype)getSearchShopModelWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initSearchShopModelWithDictionary:dictionary];
}

@end
