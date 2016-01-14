//
//  Login.h
//  Cofactories
//
//  Created by 宋国华 on 16/1/12.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//
//#import "User.h"
#import <Foundation/Foundation.h>

@interface Login : NSObject
//请求
@property (readwrite, nonatomic, strong) NSString *phone, *password;
@property (readwrite, nonatomic, strong) NSNumber *remember_me;

- (NSString *)toPath;
- (NSDictionary *)toParams;

+ (BOOL) isLogin;
+ (void) doLogout;

+ (BOOL)saveLoginData;
+ (NSMutableDictionary *)readLoginDataList;

+ (void)setPreUserPhone:(NSString *)phoneStr;
+ (NSString *)preUserPhone;


@end
