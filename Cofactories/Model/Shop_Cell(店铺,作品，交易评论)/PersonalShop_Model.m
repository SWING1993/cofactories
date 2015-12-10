//
//  PersonalShop_Model.m
//  Cofactories
//
//  Created by GTF on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "PersonalShop_Model.h"

@implementation PersonalShop_Model
- (instancetype)initPersonalShopModelWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.goodsID = [NSString stringWithFormat:@"%@",dictionary[@"id"]];
        self.goodsName = [NSString stringWithFormat:@"%@",dictionary[@"name"]];
        self.goodsPrice = [NSString stringWithFormat:@"%@",dictionary[@"price"]];
        self.goodsSales = [NSString stringWithFormat:@"%@",dictionary[@"sales"]];
        self.photoArray = dictionary[@"photo"];
    }
    return self;
}

+ (instancetype)getPersonalShopModelWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initPersonalShopModelWithDictionary:dictionary];
}

@end
