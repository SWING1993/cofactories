//
//  SupplierOrderModel.m
//  Cofactories
//
//  Created by GTF on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "SupplierOrderModel.h"

@implementation SupplierOrderModel

- (instancetype)initSupplierOrderModelWithDictionary:(NSDictionary *)dictionary{
    if (self == [super init]) {
        self.amount = dictionary[@"amount"];
        self.bidCount = [NSString stringWithFormat:@"%@",dictionary[@"bidCount"]];
        NSString *creatString = dictionary[@"createdAt"];
        NSArray *creatArray = [Tools WithTime:creatString];
        self.createdAt = (NSString *)[creatArray firstObject];
        
        NSString *saleString = [NSString stringWithFormat:@"%@",dictionary[@"description"]];
        if ([saleString isEqualToString:@"<null>"]){
            self.descriptions = @"商家未填写备注";
        }else{
            self.descriptions = dictionary[@"description"];
        }
        
        self.ID = dictionary[@"id"];
        self.name = dictionary[@"name"];
        self.photoArray = dictionary[@"photo"];
        
        NSString *statusString = [NSString stringWithFormat:@"%@",dictionary[@"status"]];
        self.status = statusString;
        
        NSString *typeString = [NSString stringWithFormat:@"%@",dictionary[@"type"]];
        if ([typeString isEqualToString:@"fabric"]) {
            self.type = @"面料";
        }else if ([typeString isEqualToString:@"accessory"]){
            self.type = @"辅料";
        }else if ([typeString isEqualToString:@"machine"]){
            self.type = @"机械设备";
        }else{
            self.type = @"空类型";
        }
        
        self.unit = dictionary[@"unit"];
        self.userUid = [NSString stringWithFormat:@"%@",dictionary[@"userUid"]];
    }
    return self;
}

+ (instancetype)getSupplierOrderModelWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initSupplierOrderModelWithDictionary:dictionary];
}
@end
