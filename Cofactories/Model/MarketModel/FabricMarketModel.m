//
//  FabricMarketModel.m
//  Cofactories
//
//  Created by GTF on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "FabricMarketModel.h"

@implementation FabricMarketModel

- (instancetype)initFabricMarketModelWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.amount = dictionary[@"amount"];
        
        NSString *creatString = dictionary[@"createdAt"];
        NSArray *creatArray = [Tools WithTime:creatString];
        self.createdAt = (NSString *)[creatArray firstObject];
        
        if ([dictionary[@"type"] isEqualToString:@"knit"]) {
            self.type = @"针织";
        }else if ([dictionary[@"type"] isEqualToString:@"woven"]){
            self.type = @"梭织";
        }else if ([dictionary[@"type"] isEqualToString:@"special"]){
            self.type = @"特种面料";
        }
        
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
        self.usage = dictionary[@"usage"];
        self.width = dictionary[@"width"];
    }
    return self;
}

+ (instancetype)getFabricMarketModelWithDictionary:(NSDictionary *)dictionary{
    
    return [[self alloc]initFabricMarketModelWithDictionary:dictionary];
}

@end
