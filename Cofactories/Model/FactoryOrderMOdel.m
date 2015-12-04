//
//  FactoryOrderMOdel.m
//  Cofactories
//
//  Created by GTF on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "FactoryOrderMOdel.h"

@implementation FactoryOrderMOdel

- (instancetype)initSupplierOrderModelWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.amount = dictionary[@"amount"];
        self.bidCount = [NSString stringWithFormat:@"%@",dictionary[@"bidCount"]];
        NSString *creatString = dictionary[@"createdAt"];
        NSArray *creatArray = [Tools WithTime:creatString];
        self.createdAt = (NSString *)[creatArray firstObject];
        self.deadline = dictionary[@"deadline"];
        
        NSString *saleString = [NSString stringWithFormat:@"%@",dictionary[@"description"]];
        if ([saleString isEqualToString:@"<null>"]){
            self.descriptions = @"商家未填写备注";
        }else{
            self.descriptions = dictionary[@"description"];
        }
        
        self.ID = dictionary[@"id"];
        self.photoArray = dictionary[@"photo"];
        
        NSString *statusString = [NSString stringWithFormat:@"%@",dictionary[@"status"]];
        self.status = statusString;
        
        self.subRole = dictionary[@"subRole"];
        
        NSString *typeString = [NSString stringWithFormat:@"%@",dictionary[@"type"]];
        if ([typeString isEqualToString:@"knit"]) {
            self.type = @"针织";
        }else if ([typeString isEqualToString:@"woven"]){
            self.type = @"梭织";
        }else{
            self.type = @"加工配套";
        }
        
        self.userUid = [NSString stringWithFormat:@"%@",dictionary[@"userUid"]];
    }
    return self;
}

+ (instancetype)getSupplierOrderModelWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initSupplierOrderModelWithDictionary:dictionary];
}

@end
