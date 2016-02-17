//
//  MeHistoryOrderModel.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/17.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "MeHistoryOrderModel.h"

@implementation MeHistoryOrderModel

- (instancetype)initMeHistoryOrderModelWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        
        self.photoArray = dictionary[@"products"][0][@"photo"];
        self.name = dictionary[@"products"][0][@"name"];
        self.price = [NSString stringWithFormat:@"%.2f", [dictionary[@"products"][0][@"price"] floatValue]];
        self.category = dictionary[@"products"][0][@"category"];
        self.amount = [NSString stringWithFormat:@"%ld", [dictionary[@"products"][0][@"amount"] integerValue]];
        self.totalPrice = [NSString stringWithFormat:@"%.2f", [dictionary[@"fee"] floatValue]];
        self.descriptions = dictionary[@"products"][0][@"description"];
        
        self.personName = dictionary[@"products"][0][@"name"];
        self.personPhone = [NSString stringWithFormat:@"%@", dictionary[@"address"][@"phone"]];
        self.personAddress = [NSString stringWithFormat:@"%@ %@ %@ %@", dictionary[@"address"][@"province"], dictionary[@"address"][@"city"], dictionary[@"address"][@"district"], dictionary[@"address"][@"address"]];
        self.creatTime = [NSString stringWithFormat:@"%@", dictionary[@"createdTime"]];
        self.orderNumber = [NSString stringWithFormat:@"%@", dictionary[@"_id"]];
        if ([dictionary[@"status"] isEqualToString:@"wait_buyer_pay"]) {
            self.waitPayType = @"等待买家付款";
            self.payType = @"付款";
        } else if([dictionary[@"status"] isEqualToString:@"wait_seller_send"]) {
            self.waitPayType = @"买家已付款";
            self.payType = @"联系卖家";
        } else if([dictionary[@"status"] isEqualToString:@"wait_buyer_receive"]) {
            self.waitPayType = @"卖家已发货";
            self.payType = @"确认收货";
        } else if ([dictionary[@"status"] isEqualToString:@"wait_comment"]) {
            self.waitPayType = @"交易成功";
            self.payType = @"评价";
        }
        self.userId = [NSString stringWithFormat:@"%@", dictionary[@"products"][0][@"userUid"]];
    }
    return self;

}
+ (instancetype)getMeHistoryOrderModelWithDictionary:(NSDictionary *)dictionary{
    
    return [[self alloc]initMeHistoryOrderModelWithDictionary:dictionary];
}

@end
