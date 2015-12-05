//
//  ProcessingAndComplitonOrderModel.m
//  Cofactories
//
//  Created by GTF on 15/12/3.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ProcessingAndComplitonOrderModel.h"

@implementation ProcessingAndComplitonOrderModel

- (instancetype)initProcessingAndComplitonOrderModelWithDictionary:(NSDictionary *)dictionary{
    if (self =[super init]) {
        
        NSString *creatString = dictionary[@"createdAt"];
        NSArray *creatArray = [Tools WithTime:creatString];
        self.createdAt = (NSString *)[creatArray firstObject];
        
        self.ID = dictionary[@"id"];
        self.photoArray = dictionary[@"photo"];

        NSString *orderTypeString = [NSString stringWithFormat:@"%@",dictionary[@"orderType"]];
        if ([orderTypeString isEqualToString:@"factory"]) {
            self.orderType = @"加工订单";
        }else if ([orderTypeString isEqualToString:@"design"]) {
            self.orderType = @"设计师订单";
        }else if ([orderTypeString isEqualToString:@"supply"]) {
            self.orderType = @"供应商订单";
        }else {
            self.orderType = @"投标订单";
        }
        
        self.orderStatus = [NSString stringWithFormat:@"%@",dictionary[@"status"]];
        
    }return self;
}


+ (instancetype)getProcessingAndComplitonOrderModelWithDictionary:(NSDictionary *)dictionary{
    return  [[self alloc] initProcessingAndComplitonOrderModelWithDictionary:dictionary];

}
@end
