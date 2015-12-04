//
//  BidManage_Supplier_Model.m
//  Cofactories
//
//  Created by GTF on 15/12/4.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "BidManage_Supplier_Model.h"

@implementation BidManage_Supplier_Model
- (instancetype)initBidManage_Supplier_ModelWithDictionary:(NSDictionary *)dictionary{
    if (self =[super init]) {
        self.userName = [NSString stringWithFormat:@"%@",dictionary[@"name"]];
        self.userphone = [NSString stringWithFormat:@"%@",dictionary[@"phone"]];
        
        NSDictionary *orderDictionary = dictionary[@"orderSupplyBid"];
        
        self.photoArray = orderDictionary[@"photo"];
        self.price = [NSString stringWithFormat:@"%@",orderDictionary[@"price"]];
        self.source = [NSString stringWithFormat:@"%@",orderDictionary[@"source"]];
        self.userID = [NSString stringWithFormat:@"%@",orderDictionary[@"userUid"]];
        self.descriptions = [NSString stringWithFormat:@"%@",orderDictionary[@"description"]];
        
    }
    return self;
}

+ (instancetype)getBidManage_Supplier_ModelWithDictionary:(NSDictionary *)dictionary{
    return  [[self alloc] initBidManage_Supplier_ModelWithDictionary:dictionary];
}

@end
