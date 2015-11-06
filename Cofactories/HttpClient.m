//
//  HttpClient.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/6.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "HttpClient.h"
#import "AFHTTPRequestSerializer+OAuth2.h"
#import "UpYun.h"
#import "AFNetworking.h"

#define kClientID @"123"
#define kSecret @"123"
#define API_reset @"/user/reset"
#define API_modifyPassword @"/user/password"
#define API_login @"/user/login"
#define API_verify @"/user/code"
#define API_checkCode @"/user/checkCode"
#define API_register @"/user/register/v2"
#define API_userProfile @"/user/profile"
#define API_favorite @"/user/favorite"
#define API_factoryProfile @"/factory/profile"
#define API_search @"/search"
#define API_searchFactory @"/search/factory"
#define API_drawAccess @"/draw/access"
#define API_updateMenu @"/menu/edit"
#define API_getMenu @"/menu/list"

#define API_searchOrder @"/search/order"
#define API_addOrder @"/order/add"
#define API_orderDetail @"/order"
#define API_closeOrder @"/order/close"
#define API_orderDoing @"/order/doing"
#define API_historyOrder @"/order/history"
#define API_interestOrder @"/order/interest"
#define API_bidOrder @"/order/bid"
#define API_deleteOrder @"/order/"


#define API_partnerList @"/partner/list"
#define API_addPartner @"/partner/add"
#define API_message @"/message"
#define API_pushSetting @"/push/setting"
#define API_pushRegister @"/push/register"
#define API_verifyModify @"/verify/modify"
#define API_verifyInfo @"/verify/info"
#define API_factoryPhoto @"/factory/photo"
#define API_uploadFactory @"/upload/factory"
#define API_uploadVerify @"/upload/verify"
#define API_uploadOrder @"upload/order"
#define API_uploadMaterial @"/upload/material"
#define API_registBid @"/order/bid/"
#define API_sendMaterial @"/material/buy"
#define API_sendMaterialHistory @"/material/history"
#define API_searchMaterial @"/search/material"
#define API_addMaterial @"/material/shop/add"
#define API_bidMaterial @"/material/buy/bid"
#define API_searchBidMaterial @"/search/materialBuy"
#define API_deleteMateria @"/material/shop/"
#define API_GetIMToken @"/im/token"

@implementation HttpClient

//发送手机验证码
+ (void)postVerifyCodeWithPhone:(NSString *)phoneNumber andBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSParameterAssert(phoneNumber);
    if (phoneNumber.length != 11) {
        block(@{@"statusCode": @(401), @"message": @"邀请码或者验证码错误！"});// 手机格式不正确
        return;
    }
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_verify parameters:@{@"phone": phoneNumber} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(@{@"statusCode": @(200), @"message": @"发送成功！"});
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        switch ((int)[operation.response statusCode]) {
            case 400:
                block(@{@"statusCode": @(400), @"message": @"手机格式不正确！"});
                break;
            case 409:
                block(@{@"statusCode": @(409), @"message": @"需要等待冷却！"});
                break;

            default:
                block(@{@"statusCode": @(502), @"message": @"发送错误！"});
                break;
        }
    }];
}

//验证 验证码
+ (void)validateCodeWithPhone:(NSString *)phoneNumber code:(NSString *)code andBlock:(void (^)(int))block {
    NSParameterAssert(phoneNumber);
    NSParameterAssert(code);
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:API_checkCode parameters:@{@"phone": phoneNumber, @"code": code} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(200);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(401);
    }];
}


//注册V2
+ (void)registerWithUsername:(NSString *)username password:(NSString *)password factoryType:(int)type  code:(NSString *)code  factoryName:(NSString *)factoryName andBlock:(void (^)(NSDictionary *responseDictionary))block {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_register parameters:@{@"phone": username, @"password": password,@"code": code, @"factoryType": @(type), @"factoryName": factoryName} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(@{@"statusCode": @(200), @"message": @"注册成功"});
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        switch ([operation.response statusCode]) {
            case 401:
                block(@{@"statusCode": @(401), @"message": @"邀请码或者验证码错误"});
                break;
            case 409:
                block(@{@"statusCode": @(409), @"message": @"该手机已经注册过"});
                break;
                
            default:
                block(@{@"statusCode": @(0), @"message": @"网络错误"});
                break;
        }
    }];
}


//登录
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password andBlock:(void (^)(int))block {
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl] clientID:kClientID secret:kSecret];
    
    [OAuth2Manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    OAuth2Manager.requestSerializer.timeoutInterval = 3.f;
    [OAuth2Manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [OAuth2Manager authenticateUsingOAuthWithURLString:API_login username:username password:password scope:@"/" success:^(AFOAuthCredential *credential) {
        // 存储 access_token
        [AFOAuthCredential storeCredential:credential withIdentifier:OAuth2Manager.serviceProviderIdentifier];
        /*
         // 保存用户身份
         [self getUserProfileWithBlock:^(NSDictionary *responseDictionary) {
         
         if ([[responseDictionary objectForKey:@"statusCode"] intValue] == 200) {
         DLog(@"登录信息:%@",[responseDictionary objectForKey:@"model"] );
         }
         }];
         */
        block(200);// 登录成功
    } failure:^(NSError *error) {
        if ([[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode] == 400) {
            block(400);// 用户名密码错误
        } else {
            block(0);// 网络错误
        }
    }];
}

//返回登录凭证 Token
+ (AFOAuthCredential *)getToken {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    return [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
}

//删除登录凭证 Token
+ (BOOL)deleteToken {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    return [AFOAuthCredential deleteCredentialWithIdentifier:serviceProviderIdentifier];
}

//刷新token
+ (void)validateOAuthWithBlock:(void (^)(int))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 存在 access_token
        if (!credential.isExpired) {
            // access_token & refresh_token 没有过期
            AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:baseUrl clientID:kClientID secret:kSecret];
            [OAuth2Manager authenticateUsingOAuthWithURLString:API_login refreshToken:credential.refreshToken success:^(AFOAuthCredential *credential) {
                // 存储 access_token
                [AFOAuthCredential storeCredential:credential withIdentifier:OAuth2Manager.serviceProviderIdentifier];
                block(200);// 刷新 access_token 成功
            } failure:^(NSError *error) {
                block(0);// 网络错误
            }];
        } else {
            block(404);//token过期
            DLog(@" access_token & refresh_token 已经过期");
            // access_token & refresh_token 已经过期
            // 重新登录
            /*
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             NSString *username = [userDefaults objectForKey:@"username"];
             NSString *password = [userDefaults objectForKey:@"password"];
             AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:baseUrl clientID:kClientID secret:kSecret];
             [OAuth2Manager authenticateUsingOAuthWithURLString:API_login username:username password:password scope:@"/" success:^(AFOAuthCredential *credential) {
             // 存储 access_token
             [AFOAuthCredential storeCredential:credential withIdentifier:OAuth2Manager.serviceProviderIdentifier];
             block(200);// 刷新 access_token 成功
             } failure:^(NSError *error) {
             if ([[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode] == 400) {
             block(400);// 用户名密码错误
             } else {
             block(0);// 网络错误
             }
             }];
             */
        }
    } else {
        // 不存在 access_token
        block(404);
    }
}

//登出
+ (BOOL)logout {
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    return [AFOAuthCredential deleteCredentialWithIdentifier:serviceProviderIdentifier];
}

//发送邀请码
+ (void)registerWithInviteCode:(NSString *)inviteCode andBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则修改用户资料
        // 构造参数字典
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:0];
        if (inviteCode) {
            [parameters setObject:inviteCode forKey:@"inviteCode"];
        }
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_userProfile parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block (responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            block (error);
        }];
    } else {
        
    }
}

//重置密码
+ (void)postResetPasswordWithPhone:(NSString *)phoneNumber code:(NSString *)code password:(NSString *)password andBlock:(void (^)(int statusCode))block {
    
    NSParameterAssert(phoneNumber);
    NSParameterAssert(password);
    NSParameterAssert(code);
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_reset parameters:@{@"phone": phoneNumber, @"password": password, @"code": code} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(200);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block((int)[operation.response statusCode]);
    }];
}

//修改密码
+ (void)modifyPassword:(NSString *)password newPassword:(NSString *)newPassword andBlock:(void (^)(int))block {
    NSParameterAssert(password);
    NSParameterAssert(newPassword);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_modifyPassword parameters:@{@"password": password, @"newPassword": newPassword} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(200);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((int)[operation.response statusCode]);
        }];
    }
}


@end
