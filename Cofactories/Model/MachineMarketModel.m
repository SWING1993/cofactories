//
//  MachineMarketModel.m
//  Cofactories
//
//  Created by GTF on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MachineMarketModel.h"

@implementation MachineMarketModel

- (instancetype)initMachineMarketModelWithDictionary:(NSDictionary *)dictionary{
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
        self.sales = dictionary[@"sales"];
        
        if ([dictionary[@"type"] isEqualToString:@"machine"]) {
            self.type = @"机械设备";
        }else if ([dictionary[@"type"] isEqualToString:@"accessory"]){
            self.type = @"机械设备配件";
        }
        
        self.unit  = dictionary[@"unit"];
        self.userUid  = dictionary[@"userUid"];

        
    }
    return self;
}

+ (instancetype)getMachineMarketModelWithDictionary:(NSDictionary *)dictionary{
    
    return [[self alloc]initMachineMarketModelWithDictionary:dictionary];
}


@end
