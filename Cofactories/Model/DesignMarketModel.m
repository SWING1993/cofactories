//
//  DesignMarketModel.m
//  Cofactories
//
//  Created by GTF on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "DesignMarketModel.h"

@implementation DesignMarketModel

- (instancetype)initDesignMarketModelWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.amount = dictionary[@"amount"];
        
        if ([dictionary[@"country"] isEqualToString:@"jp"]) {
            self.country = @"日本";
        }else if ([dictionary[@"country"] isEqualToString:@"kr"]){
            self.country = @"韩国";
        }else if ([dictionary[@"country"] isEqualToString:@"eu"]){
            self.country = @"欧美";
        }else if ([dictionary[@"country"] isEqualToString:@"cn"]){
            self.country = @"中国";
        }
        
        NSString *creatString = dictionary[@"createdAt"];
        NSArray *creatArray = [Tools WithTime:creatString];
        self.createdAt = (NSString *)[creatArray firstObject];
        
        self.descriptions = dictionary[@"description"];
        self.ID = dictionary[@"id"];
        self.name = dictionary[@"name"];
        
        if ([dictionary[@"part"] isEqualToString:@"top"]) {
            self.part = @"上装";
        }else if ([dictionary[@"part"] isEqualToString:@"bottom"]){
            self.part = @"下装";
        }else if ([dictionary[@"part"] isEqualToString:@"suit"]){
            self.part = @"套装";
        }
        
        self.price = dictionary[@"price"];
        self.photoArray = dictionary[@"photo"];
        self.sales = dictionary[@"sales"];
        
        if ([dictionary[@"type"] isEqualToString:@"male"]) {
            self.type = @"男装";
        }else if ([dictionary[@"type"] isEqualToString:@"female"]){
            self.type = @"女装";
        }else if ([dictionary[@"type"] isEqualToString:@"boy"]){
            self.type = @"男童装";
        }else if ([dictionary[@"type"] isEqualToString:@"girl"]){
            self.type = @"女童装";
        }
        
        self.userUid  = dictionary[@"userUid"];
        
        
    }
    return self;
}

+ (instancetype)getDesignMarketModelWithDictionary:(NSDictionary *)dictionary{
    
    return [[self alloc]initDesignMarketModelWithDictionary:dictionary];
}

@end
