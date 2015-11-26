//
//  AccessoryMarketModel.m
//  Cofactories
//
//  Created by GTF on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "AccessoryMarketModel.h"

@implementation AccessoryMarketModel

- (instancetype)initAccessoryMarketModelWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.amount = dictionary[@"amount"];
        
        NSString *creatString = dictionary[@"createdAt"];
        NSArray *creatArray = [Tools WithTime:creatString];
        self.createdAt = (NSString *)[creatArray firstObject];

        self.descriptions = dictionary[@"description"];
        self.ID = dictionary[@"id"];
        self.name = dictionary[@"name"];
        self.price = dictionary[@"price"];
        self.photoArray = dictionary[@"photo"];
        
        NSString *saleString = [NSString stringWithFormat:@"%@",dictionary[@"sales"]];
        if ([saleString isEqualToString:@"<null>"]) {
            self.sales = @"暂未售出";
        }else{
            self.sales = dictionary[@"sales"];
        }
        
        self.unit = dictionary[@"unit"];
        self.userUid  = dictionary[@"userUid"];
        
    }
    return self;
}

+ (instancetype)getAccessoryMarketModelWithDictionary:(NSDictionary *)dictionary{
    
    return [[self alloc]initAccessoryMarketModelWithDictionary:dictionary];
}

@end
