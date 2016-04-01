//
//  IMSearchResultModel.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/31.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "IMSearchResultModel.h"

@implementation IMSearchResultModel
- (instancetype)initBusinessSupplierModelWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.businessUid = [NSString stringWithFormat:@"%@",dictionary[@"uid"]];
        self.businessName = [NSString stringWithFormat:@"%@",dictionary[@"name"]];
        //
        //        NSString *enterpriseString = [NSString stringWithFormat:@"%@",dictionary[@"enterprise"]];
        //        if ([enterpriseString isEqualToString:@"<null>"] || enterpriseString == nil || [enterpriseString isEqualToString:@"0"]) {
        //            self.businessEnterprise = @"非企业用户";
        //        }else{
        //            self.businessEnterprise = @"企业用户";
        //        }
        //
        //        if ([self.businessEnterprise isEqualToString:@"企业用户"]) {
        //            self.businessVerified = @"认证用户";
        //        }else{
        //            NSString *verifiedString = [NSString stringWithFormat:@"%@",dictionary[@"verified"]];
        //            if ([verifiedString isEqualToString:@"<null>"] || verifiedString == nil || [verifiedString isEqualToString:@"0"]) {
        //                self.businessVerified = @"非认证用户";
        //            }else{
        //                self.businessVerified = @"认证用户";
        //            }
        //        }
        
        NSString *verifiedStr = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"verified"]];
        NSString *enterpriseStr = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"enterprise"]];
        if ([enterpriseStr isEqualToString:@"<null>"]) {
            if ([verifiedStr isEqualToString:@"<null>"]) {
                _userIdentity = @"非认证用户";
            }else{
                _userIdentity = @"认证用户";
            }
        }else if ([enterpriseStr isEqualToString:@"0"]){
            //企业账号的住账号
            _userIdentity = @"企业用户";
        }else{
            //企业账号的子账号
            _userIdentity = @"企业用户";
        }
        
        
        NSString *subroleString = [NSString stringWithFormat:@"%@",dictionary[@"subRole"]];
        if ([subroleString isEqualToString:@"<null>"] || subroleString == nil) {
            self.businessSubrole = @"子身份暂无";
        }else{
            self.businessSubrole = subroleString;
        }
        
        NSString *cityString = [NSString stringWithFormat:@"%@",dictionary[@"city"]];
        if ([cityString isEqualToString:@"<null>"] || cityString == nil) {
            self.businessCity = @"地址: 未填写";
        }else{
            self.businessCity = [NSString stringWithFormat:@"地址: %@",cityString];
        }
        
        self.businessScore = [NSString stringWithFormat:@"%@",dictionary[@"score"]];
        
    }
    return self;
}

+ (instancetype)getBusinessSupplierModelWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initBusinessSupplierModelWithDictionary:dictionary];
}

@end
