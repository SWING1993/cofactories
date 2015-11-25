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

/*User**********************************************************************************************************************************************/

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
+ (void)validateCodeWithPhone:(NSString *)phoneNumber code:(NSString *)code andBlock:(void (^)(NSInteger statusCode))block;


/*!
 注册账号
  
 @param username            用户名(手机号码)
 @param password            密码
 @param type                工厂类型(enum)
 @param code                验证码
 @param factoryName         工厂名称

 @param block               回调函数 会返回 @{@"statusCode": @201, @"responseObject": 字典}->(注册成功) @{@"statusCode": @401, @"message": @"验证码错误"}->(验证码错误) @{@"statusCode": @409, @"message": @"该手机已经注册过""}->(手机已经注册过) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误)
 */
+ (void)registerWithUsername:(NSString *)username password:(NSString *)password UserRole:(NSString *)role  code:(NSString *)code  UserName:(NSString *)name andBlock:(void (^)(NSDictionary *responseDictionary))block;

/*!
 登录账号
 
 @param username 用户名(手机号码)
 @param password 密码
 @param block    回调函数 会返回 0->(网络错误) 200->(登录成功) 400->(用户名密码错误)
 */
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password andBlock:(void (^)(NSInteger statusCode))block;


/*!
 刷新 access_token
 
 @param block 回调函数 会返回 0->(网络错误) 200->(成功) 400->(用户名密码错误) 404->(access_token不存在)
 */
+ (void)validateOAuthWithBlock:(void (^)(NSInteger statusCode))block;

/*!
 返回登录凭据
 
 @return 返回 AFOAuthCredential 包含 access_token 等登录信息
 */
+ (AFOAuthCredential *)getToken;

/*!
 退出账号  删除凭据
 
 @return 返回 BOOL 值表示是否成功删除
 */
+ (BOOL)deleteToken;


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
+ (void)postResetPasswordWithPhone:(NSString *)phoneNumber code:(NSString *)code password:(NSString *)password andBlock:(void (^)(NSInteger statusCode))block;
/*!
 修改密码
 
 @param password    旧密码
 @param newPassword 新密码
 @param block       回调函数 会返回 0->(网络错误) 200->(成功) 403->(旧密码错误) 404->(access_token不存在)
 */
+ (void)modifyPassword:(NSString *)password newPassword:(NSString *)newPassword andBlock:(void (^)(NSInteger statusCode))block;


/*!
 获取用户资料
 
 @param block 回调函数 会返回 @{@"statusCode": @200, @"model": UserModel对象}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"} @{@"statusCode": @401, @"message": @"access_token过期或者无效"} @{@"statusCode": @404, @"message": @"access_token不存在"}
 */
+ (void)getMyProfileWithBlock:(void (^)(NSDictionary *responseDictionary))block;

/**
 *  修改自己的资料
 *   address 地址，需要拼接上完整的省市区
 province 市
 district 区
 description 备注
 scale 规模
 subRole 第二身份
 *  @param Dic   修改的字典
 *  @param block 返回状态码 200为修改成功
 */
+ (void)postMyProfileWithDic:(NSMutableDictionary *)Dic andBlock:(void (^)(NSInteger statusCode))block;


/**
 *  获取自己的钱包
 *
 *  @param block 回调函数  200 OK  返回钱包Model
 
 */
+ (void)getwalletWithBlock:(void (^)(NSDictionary *responseDictionary))block;

/**
 *  上传认证资料
 *
 *  @param enterpriseName    企业名称
 *  @param personName        法人姓名
 *  @param idCard            身份证号
 *  @param enterpriseAddress 企业地址
 *  @param block             返回状态码 200为成功
 */
+ (void)postVerifyWithenterpriseName:(NSString *)enterpriseName withpersonName:(NSString *)personName withidCard:(NSString *)idCard withenterpriseAddress:(NSString *)enterpriseAddress andBlock:(void (^)(NSInteger statusCode))block;

/*Config**********************************************************************************************************************************************/
/**
 *  获取广告
 *
 *  @param block 返回参数 200 广告Model
 */

+ (void)getConfigWithType:(NSString *)type WithBlock:(void (^)(NSDictionary *responseDictionary))block;


@end
