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
        
        if (![[dictionary objectForKey:@"amount"] isEqual:[NSNull null]] ) {
            _fee = [[dictionary objectForKey:@"amount"] floatValue];
        }
        
        if (![[dictionary objectForKey:@"usage"] isEqual:[NSNull null]] ) {
            if ([[dictionary objectForKey:@"usage"] isEqualToString:@"charge"]) {
                _type = @"充值";
 
            }
            else if ([[dictionary objectForKey:@"usage"] isEqualToString:@"order"]) {
                _type = @"订单保证金";

            }
            else if ([[dictionary objectForKey:@"usage"] isEqualToString:@"market"]) {
                _type = @"商城交易";
                
            }
            else if ([[dictionary objectForKey:@"usage"] isEqualToString:@"withDraw"]) {
                _type = @"提现";
            }
            else {
                _type = [dictionary objectForKey:@"usage"];

            }
        } else {
             _type = @"交易";
        }
        
        if (![[dictionary objectForKey:@"createdAt"] isEqual:[NSNull null]] ) {
            _createdTime = [dictionary objectForKey:@"createdAt"];
        }
        
        if (![[dictionary objectForKey:@"updatedAt"] isEqual:[NSNull null]] ) {
            _finishedTime = [dictionary objectForKey:@"updatedAt"];
        }
        
    }
    return self;
}

@end
