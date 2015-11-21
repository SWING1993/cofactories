//
//  UserModel.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/21.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserType) {
    UserType_designer,    //设计者
    UserType_clothing,    //服装企业
    UserType_processing,  //加工配套
    UserType_supplier,    //供应商
    UserType_facilitator, //服务商
};

@interface UserModel : NSObject
@property (nonatomic, assign) UserType UserType;
@property (nonatomic, strong) NSArray * UserTypeListArray;
@property (nonatomic, strong) NSArray * UserTypeArray;


@end
