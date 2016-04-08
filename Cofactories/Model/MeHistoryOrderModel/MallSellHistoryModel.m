//
//  MallSellHistoryModel.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/21.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallSellHistoryModel.h"

@implementation MallSellHistoryModel
- (instancetype)initMeHistoryOrderModelWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        
        self.photoArray = dictionary[@"products"][0][@"photo"];
        self.name = dictionary[@"products"][0][@"name"];
        self.price = [NSString stringWithFormat:@"%.2f", [dictionary[@"products"][0][@"price"] floatValue]];
        self.category = dictionary[@"products"][0][@"category"];
        self.amount = [NSString stringWithFormat:@"%ld", [dictionary[@"products"][0][@"amount"] integerValue]];
        self.totalPrice = [NSString stringWithFormat:@"%.2f", [dictionary[@"fee"] floatValue]];
        self.descriptions = dictionary[@"products"][0][@"description"];
        
        self.personName = dictionary[@"address"][@"name"];
        self.personPhone = [NSString stringWithFormat:@"%@", dictionary[@"address"][@"phone"]];
        self.personAddress = [NSString stringWithFormat:@"%@ %@ %@ %@", dictionary[@"address"][@"province"], dictionary[@"address"][@"city"], dictionary[@"address"][@"district"], dictionary[@"address"][@"address"]];
        self.creatTime = [NSString stringWithFormat:@"%@", dictionary[@"createdTime"]];
        self.orderNumber = [NSString stringWithFormat:@"%@", dictionary[@"_id"]];
        self.payment = [NSString stringWithFormat:@"%@", dictionary[@"payment"]];
        if ([dictionary[@"status"] isEqualToString:@"wait_buyer_pay"]) {
            
            self.waitPayType = @"等待买家付款";
            self.payType = @"付款";
            self.mallOrderTitle = @"待付款订单";
            self.status = 1;
            self.showButton = NO;
        } else if([dictionary[@"status"] isEqualToString:@"wait_seller_send"]) {
            self.waitPayType = @"买家已付款";
            self.payType = @"联系卖家";
            self.mallOrderTitle = @"待发货订单";
            self.status = 2;
            self.showButton = YES;
        } else if([dictionary[@"status"] isEqualToString:@"wait_buyer_receive"]) {
            self.waitPayType = @"卖家已发货";
            self.payType = @"确认收货";
            self.mallOrderTitle = @"待收货订单";
            self.status = 3;
            self.showButton = NO;
        } else if ([dictionary[@"status"] isEqualToString:@"wait_comment"]) {
            self.waitPayType = @"交易成功";
            //            self.payType = @"评价";
            self.mallOrderTitle = @"待评价订单";
            self.status = 4;
            self.showButton = YES;
        } else if ([dictionary[@"status"] isEqualToString:@"finish"]) {
            self.waitPayType = @"交易成功";
            self.payType = @"已完成";
            self.mallOrderTitle = @"已完成订单";
            self.status = 5;
            self.showButton = YES;
        } else {
            self.status = 0;
            self.waitPayType = @"商城订单";
            self.payType = @"商城订单";
            self.mallOrderTitle = @"订单详情";
            self.showButton = NO;
        }
        self.sellerUserId = [NSString stringWithFormat:@"%@", dictionary[@"seller"]];
        self.buyerUserId = [NSString stringWithFormat:@"%@", dictionary[@"buyer"]];
        self.payTime = [NSString stringWithFormat:@"%@", dictionary[@"payTime"]];
        self.sendTime = [NSString stringWithFormat:@"%@", dictionary[@"sendTime"]];
        self.receiveTime = [NSString stringWithFormat:@"%@", dictionary[@"receiveTime"]];
        self.comment = [NSString stringWithFormat:@"%@", dictionary[@"comment"]];
        
        
    }
    return self;
    
}
+ (instancetype)getMeHistoryOrderModelWithDictionary:(NSDictionary *)dictionary{
    
    return [[self alloc]initMeHistoryOrderModelWithDictionary:dictionary];
}

@end
