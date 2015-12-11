//
//  Supplier_Business_Midel.m
//  Cofactories
//
//  Created by GTF on 15/12/8.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "Business_Supplier_Model.h"

@implementation Business_Supplier_Model

- (instancetype)initBusinessSupplierModelWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.businessUid = [NSString stringWithFormat:@"%@",dictionary[@"uid"]];
        self.businessName = [NSString stringWithFormat:@"%@",dictionary[@"name"]];
        
        NSString *enterpriseString = [NSString stringWithFormat:@"%@",dictionary[@"enterprise"]];
        if ([enterpriseString isEqualToString:@"<null>"] || enterpriseString == nil) {
            self.businessEnterprise = @"非企业用户";
        }else{
            self.businessEnterprise = @"企业用户";
        }
        
        if ([self.businessEnterprise isEqualToString:@"企业用户"]) {
            self.businessVerified = @"认证用户";
        }else{
            NSString *verifiedString = [NSString stringWithFormat:@"%@",dictionary[@"verified"]];
            if ([verifiedString isEqualToString:@"<null>"] || verifiedString == nil) {
                self.businessVerified = @"非认证用户";
            }else{
                self.businessVerified = @"认证用户";
            }
        }
        
        NSString *subroleString = [NSString stringWithFormat:@"%@",dictionary[@"subRole"]];
        if ([subroleString isEqualToString:@"<null>"] || subroleString == nil) {
            self.businessSubrole = @"子身份暂无";
        }else{
            self.businessSubrole = subroleString;
        }
        
        NSString *cityString = [NSString stringWithFormat:@"%@",dictionary[@"city"]];
        if ([cityString isEqualToString:@"<null>"] || cityString == nil) {
            self.businessCity = @"地址未填写";
        }else{
            self.businessCity = cityString;
        }
        
        self.businessScore = [NSString stringWithFormat:@"%@",dictionary[@"score"]];
        
    }
    return self;
}

+ (instancetype)getBusinessSupplierModelWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initBusinessSupplierModelWithDictionary:dictionary];
}

@end
