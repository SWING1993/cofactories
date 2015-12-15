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
        self.amount = [NSString stringWithFormat:@"%@", dictionary[@"amount"]];
        
        NSString *creatString = dictionary[@"createdAt"];
        NSArray *creatArray = [Tools WithTime:creatString];
        self.createdAt = (NSString *)[creatArray firstObject];
        
//        if ([dictionary[@"type"] isEqualToString:@"knit"]) {
//            self.type = @"针织";
//        }else if ([dictionary[@"type"] isEqualToString:@"woven"]){
//            self.type = @"梭织";
//        }else if ([dictionary[@"type"] isEqualToString:@"special"]){
//            self.type = @"特种面料";
//        }else if ([dictionary[@"type"] isEqualToString:@"machine"]){
//            self.type = @"机械设备";
//        }else if ([dictionary[@"type"] isEqualToString:@"part"]){
//            self.type = @"配件";
//        }else if ([dictionary[@"type"] isEqualToString:@"male"]){
//            self.type = @"男装";
//        }else if ([dictionary[@"type"] isEqualToString:@"female"]){
//            self.type = @"女装";
//        }else if ([dictionary[@"type"] isEqualToString:@"boy"]){
//            self.type = @"男童";
//        }else if ([dictionary[@"type"] isEqualToString:@"girl"]){
//            self.type = @"女童";
//        }else {
//            self.type = @"暂无";
//        }

        
        self.market = dictionary[@"market"];
        
        self.descriptions = dictionary[@"description"];
        self.ID = [NSString stringWithFormat:@"%@", dictionary[@"id"]];
        self.name = dictionary[@"name"];
        self.price = [NSString stringWithFormat:@"%.2f", [dictionary[@"price"] floatValue]];
        self.marketPrice = [NSString stringWithFormat:@"%.2f", [dictionary[@"marketPrice"] floatValue]];
        self.enterPrisePrice = [NSString stringWithFormat:@"%.2f", [dictionary[@"enterprisePrice"] floatValue]];
        self.photoArray = dictionary[@"photo"];
        self.catrgoryArray = dictionary[@"category"];
        
        NSString *saleString = [NSString stringWithFormat:@"%@",dictionary[@"sales"]];
        if ([saleString isEqualToString:@"<null>"]) {
            self.sales = @"暂未售出";
        }else{
            self.sales = saleString;
        }
        
        NSString *unitString = [NSString stringWithFormat:@"%@",dictionary[@"unit"]];
        if ([unitString isEqualToString:@"<null>"]) {
            self.unit = @"件";
        } else {
            self.unit = dictionary[@"unit"];
        }
        
        self.userUid  = dictionary[@"userUid"];
        
        
        //设计市场专有
//        if ([dictionary[@"country"] isEqualToString:@"jp"]) {
//            self.country = @"日本";
//        }else if ([dictionary[@"country"] isEqualToString:@"kr"]){
//            self.country = @"韩国";
//        }else if ([dictionary[@"country"] isEqualToString:@"eu"]){
//            self.country = @"欧美";
//        }else if ([dictionary[@"country"] isEqualToString:@"cn"]){
//            self.country = @"中国";
//        }
//
//        if ([dictionary[@"part"] isEqualToString:@"top"]) {
//            self.part = @"上衣";
//        } else if ([dictionary[@"part"] isEqualToString:@"bottom"]) {
//            self.part = @"下衣";
//        } else if ([dictionary[@"part"] isEqualToString:@"suit"]) {
//            self.part = @"套装";
//        }
//        
//        self.productId = dictionary[@"productId"];
    }
    return self;
}

+ (instancetype)getFabricMarketModelWithDictionary:(NSDictionary *)dictionary{
    
    return [[self alloc]initFabricMarketModelWithDictionary:dictionary];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name = %@, price = %@, marketPrice = %@, amount = %@, unit = %@, descriptions = %@", self.name, self.price, self.marketPrice, self.amount, self.unit, self.descriptions];
}



@end
