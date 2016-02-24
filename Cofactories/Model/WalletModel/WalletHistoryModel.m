//
//  WalletHistoryModel.m
//  Cofactories
//
//  Created by 宋国华 on 15/12/9.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "WalletHistoryModel.h"

@implementation WalletHistoryModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        
        if (![[dictionary objectForKey:@"_id"] isEqual:[NSNull null]]) {
            _Walletid = [dictionary objectForKey:@"_id"];
        }
        
        if (![[dictionary objectForKey:@"fee"] isEqual:[NSNull null]] ) {
            _fee = [[dictionary objectForKey:@"fee"] floatValue];
        }
        
        if (![[dictionary objectForKey:@"type"] isEqual:[NSNull null]] ) {
            if ([[dictionary objectForKey:@"type"] isEqualToString:@"charge"]) {
                _type = @"充值";
 
            }
            else if ([[dictionary objectForKey:@"type"] isEqualToString:@"order"]) {
                _type = @"订单保证金";

            }
            else if ([[dictionary objectForKey:@"type"] isEqualToString:@"market"]) {
                _type = @"商城购买";
                
            }
            else if ([[dictionary objectForKey:@"type"] isEqualToString:@"withDraw"]) {
                _type = @"提现";
            }
            else {
                _type = [dictionary objectForKey:@"type"];

            }
        }
        
        if ( ![[dictionary objectForKey:@"status"] isEqual:[NSNull null]] ) {
            if ([[dictionary objectForKey:@"status"] isEqualToString:@"trade_success"]) {
                _status = @"交易成功";
                
            }
            else if ([[dictionary objectForKey:@"status"] isEqualToString:@"wait_buyer_pay"]) {
                _status = @"等待支付";
                
            }
            else if ([[dictionary objectForKey:@"status"] isEqualToString:@"wait_audit"]) {
                _status = @"等待审核";
            }
            else {
                _status = [dictionary objectForKey:@"status"];
            }
        }
        
        
        if (![[dictionary objectForKey:@"createdTime"] isEqual:[NSNull null]] ) {
            _createdTime = [dictionary objectForKey:@"createdTime"];
        }
        
        if (![[dictionary objectForKey:@"finishedTime"] isEqual:[NSNull null]] ) {
            _finishedTime = [dictionary objectForKey:@"finishedTime"];
        }
        
        if (![[dictionary objectForKey:@"products"] isEqual:[NSNull null]] ) {
            _products = [dictionary objectForKey:@"products"];
        }
    }
    return self;
}

@end
