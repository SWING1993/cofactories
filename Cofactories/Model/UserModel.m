//
//  UserModel.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/21.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.UserTypeListArray = [[NSArray alloc]initWithObjects:@"设计者",@"服装企业",@"供应商",@"加工配套企业",@"服务商", nil];
        
        self.UserTypeArray = [[NSArray alloc]initWithObjects:@"designer",@"clothing",@"processing",@"supplier",@"facilitator", nil];
    }
    return self;
}

@end
