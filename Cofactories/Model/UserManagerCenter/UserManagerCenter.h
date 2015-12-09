//
//  UserManagerCenter.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/23.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#ifndef UserManagerCenter_h
#define UserManagerCenter_h

#import "UserModel.h"
#import "StoreUserValue.h"
#import "NSObject+StoreValue.h"

#endif /* UserManagerCenter_h */

/*
 个人信息已写入到本地   若要查询自己的信息 采用如下方式     然后打点调用自己的详细信息
 
 当个人信息有更新是 需要请求一下[HttpClient getMyProfileWithBlock:^(NSDictionary *responseDictionary)]  这样本地存储的就是最新的信息  否则不需要再次请求
 
 UserModel * model = [[UserModel alloc]getMyProfile];

 model.uid
 model.UserType
 ...

 */
