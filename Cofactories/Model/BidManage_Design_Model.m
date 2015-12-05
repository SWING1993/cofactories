//
//  BidManage_Design_Model.m
//  Cofactories
//
//  Created by GTF on 15/12/5.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "BidManage_Design_Model.h"

@implementation BidManage_Design_Model

- (instancetype)initBidManage_Design_ModelWithDictionary:(NSDictionary *)dictionary{
    if (self =[super init]) {
        self.userName = [NSString stringWithFormat:@"%@",dictionary[@"name"]];
        self.userphone = [NSString stringWithFormat:@"%@",dictionary[@"phone"]];
        
        NSDictionary *orderDictionary = dictionary[@"orderDesignBid"];
        
        self.photoArray = orderDictionary[@"photo"];
        self.userID = [NSString stringWithFormat:@"%@",orderDictionary[@"userUid"]];
        self.descriptions = [NSString stringWithFormat:@"%@",orderDictionary[@"description"]];
        
    }
    return self;
}

+ (instancetype)getBidManage_Design_ModelWithDictionary:(NSDictionary *)dictionary{
    return  [[self alloc] initBidManage_Design_ModelWithDictionary:dictionary];
}
@end
