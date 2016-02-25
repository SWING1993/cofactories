//
//  MallOrderDetailModel.m
//  Cofactories
//
//  Created by 赵广印 on 16/2/22.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallOrderDetailModel.h"

@implementation MallOrderDetailModel
- (instancetype)initMallOrderDetailModelWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        
        self.photoArray = dictionary[@"products"][0][@"photo"];
        self.name = dictionary[@"products"][0][@"name"];
        self.price = [NSString stringWithFormat:@"%.2f", [dictionary[@"products"][0][@"price"] floatValue]];
        self.category = dictionary[@"products"][0][@"category"];
        self.amount = [NSString stringWithFormat:@"%ld", [dictionary[@"products"][0][@"amount"] integerValue]];
        self.totalPrice = [NSString stringWithFormat:@"%.2f", [dictionary[@"fee"] floatValue]];
        self.descriptions = dictionary[@"products"][0][@"description"];
        
        if ([dictionary[@"status"] isEqualToString:@"wait_buyer_pay"]) {
            self.waitPayType = @"等待买家付款";
            
        } else if([dictionary[@"status"] isEqualToString:@"wait_seller_send"]) {
            self.waitPayType = @"买家已付款";
            
        } else if([dictionary[@"status"] isEqualToString:@"wait_buyer_receive"]) {
            self.waitPayType = @"卖家已发货";
            
        } else if ([dictionary[@"status"] isEqualToString:@"wait_comment"]) {
            self.waitPayType = @"交易成功";
        } else {
            self.waitPayType = @"未知订单";
        }
    }
    return self;
    
}
+ (instancetype)getMallOrderDetailModelWithDictionary:(NSDictionary *)dictionary{
    
    return [[self alloc]initMallOrderDetailModelWithDictionary:dictionary];
}

@end
