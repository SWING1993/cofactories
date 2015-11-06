//
//  HttpClient.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/6.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFOAuth2Manager.h"
#import "UpYun.h"

@interface HttpClient : NSObject

/*!
 发送手机验证码
 
 @param phoneNumber 手机号码(11位)
 @param block       回调函数 会返回 0->(网络错误) 200->(成功) 400->(手机格式不正确) 409->(需要等待冷却) 502->(发送错误)
 */
+ (void)postVerifyCodeWithPhone:(NSString *)phoneNumber andBlock:(void (^)(NSDictionary *responseDictionary))block;
/*!
 校验验证码
 
 @param phoneNumber 手机号码
 @param code        验证码
 @param block       回调函数 会返回 0->(网络错误) 200->(验证码正确) 401->(验证码过期或者无效)
 */
+ (void)validateCodeWithPhone:(NSString *)phoneNumber code:(NSString *)code andBlock:(void (^)(int statusCode))block;


/*!
 注册账号
 工厂规模必须从小到大排序,如果规模范围是 x 到无限大,则 factorySizeMin = @(x), factorySizeMax = nil;
 
 @param username            用户名(手机号码)
 @param password            密码
 @param type                工厂类型(enum)
 @param code                验证码
 @param factoryName         工厂名称

 @param block               回调函数 会返回 @{@"statusCode": @201, @"responseObject": 字典}->(注册成功) @{@"statusCode": @401, @"message": @"验证码错误"}->(验证码错误) @{@"statusCode": @409, @"message": @"该手机已经注册过""}->(手机已经注册过) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误)
 */
+ (void)registerWithUsername:(NSString *)username password:(NSString *)password factoryType:(int)type  code:(NSString *)code  factoryName:(NSString *)factoryName andBlock:(void (^)(NSDictionary *responseDictionary))block;

/*!
 登录账号
 
 @param username 用户名(手机号码)
 @param password 密码
 @param block    回调函数 会返回 0->(网络错误) 200->(登录成功) 400->(用户名密码错误)
 */
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password andBlock:(void (^)(int statusCode))block;


/*!
 返回登录凭据
 
 @return 返回 AFOAuthCredential 包含 access_token 等登录信息
 */
+ (AFOAuthCredential *)getToken;

/*!
 删除凭据
 
 @return 返回 BOOL 值表示是否成功删除
 */
+ (BOOL)deleteToken;


/*!
 刷新 access_token
 
 @param block 回调函数 会返回 0->(网络错误) 200->(成功) 400->(用户名密码错误) 404->(access_token不存在)
 */
+ (void)validateOAuthWithBlock:(void (^)(int statusCode))block;

/*!
 登出账号
 
 @return BOOL 是否登出成功
 */
+ (BOOL)logout;


/*!
 发送邀请吗
 
 @param inviteCode 邀请码

 */
+ (void)registerWithInviteCode:(NSString *)inviteCode andBlock:(void (^)(NSDictionary *responseDictionary))block;

/*!
 重置密码
 
 @param phoneNumber 手机号码(11位)
 @param block       回调函数 会返回 0->(网络错误) 200->(成功) 400->(手机格式不正确) 409->(需要等待冷却) 502->(发送错误)
 */
+ (void)postResetPasswordWithPhone:(NSString *)phoneNumber code:(NSString *)code password:(NSString *)password andBlock:(void (^)(int statusCode))block;
/*!
 修改密码
 
 @param password    旧密码
 @param newPassword 新密码
 @param block       回调函数 会返回 0->(网络错误) 200->(成功) 403->(旧密码错误) 404->(access_token不存在)
 */
+ (void)modifyPassword:(NSString *)password newPassword:(NSString *)newPassword andBlock:(void (^)(int statusCode))block;



@end
