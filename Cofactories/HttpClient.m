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

#import "UserManagerCenter.h"

#pragma mark - 服务器

#define kClientID @"123"
#define kSecret @"123"

#define API_authorise @"/authorise" // authorise
#define API_verify @"/user/code" //获取验证码
#define API_checkCode @"/user/checkCode" //检查短信验证码
#define API_register @"/user/register" //注册
#define API_login @"/user/login" //登录
#define API_reset @"/user/reset"
#define API_modifyPassword @"/user/password"


#define API_userProfile @"/user/profile"
#define API_favorite @"/user/favorite"
#define API_factoryProfile @"/factory/profile"
#define API_search @"/search"
#define API_searchFactory @"/search/factory"
#define API_drawAccess @"/draw/access"


@implementation HttpClient

//发送手机验证码
+ (void)postVerifyCodeWithPhone:(NSString *)phoneNumber andBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSParameterAssert(phoneNumber);
    if (phoneNumber.length != 11) {
        block(@{@"statusCode": @(400), @"message": @"手机号码格式错误！"});// 手机格式不正确
        return;
    }
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_verify parameters:@{@"phone": phoneNumber} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        DLog(@"responseObject = %@",responseObject);
        block(@{@"statusCode": @(200), @"message": @"发送成功，十分钟内有效！"});
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        switch (statusCode) {
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
+ (void)validateCodeWithPhone:(NSString *)phoneNumber code:(NSString *)code andBlock:(void (^)(NSInteger))block {
    NSParameterAssert(phoneNumber);
    NSParameterAssert(code);
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:API_checkCode parameters:@{@"phone": phoneNumber, @"code": code} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        block(200);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(401);
    }];

}

//注册
+ (void)registerWithUsername:(NSString *)username password:(NSString *)password UserRole:(NSString *)role code:(NSString *)code UserName:(NSString *)name andBlock:(void (^)(NSDictionary *))block {
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_register parameters:@{@"phone": username, @"password": password,@"code": code, @"role": role, @"name": name} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        block(@{@"statusCode": @(200), @"message": @"注册成功!"});
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        DLog(@"error = %@", error);
        DLog(@"error = %ld",statusCode);
        switch (statusCode) {
            case 401:
                block(@{@"statusCode": @(401), @"message": @"验证码错误!"});
                break;
            case 409:
                block(@{@"statusCode": @(409), @"message": @"该手机已经注册过!"});
                break;
                
            default:
                block(@{@"statusCode": @(0), @"message": @"网络错误!"});
                break;
        }
    }];
}

//登录
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password andBlock:(void (^)(NSInteger))block {
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:[NSURL URLWithString:kAuthUrl] clientID:kClientID secret:kSecret];
    
    [OAuth2Manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    OAuth2Manager.requestSerializer.timeoutInterval = 10.f;
    [OAuth2Manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]initWithCapacity:4];
    [parameters setObject:@"code" forKey:@"response_type"];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:password forKey:@"password"];
    [parameters setObject:@"no" forKey:@"enterprise"];
    
    [OAuth2Manager POST:API_authorise parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"success = %@",responseObject);
        NSString * code = [responseObject objectForKey:@"code"];
        [self loginWithCode:code andBlock:^(NSInteger statusCode) {
            DLog(@"第二步登录验证 statusCode = %ld",(long)statusCode);
            block(statusCode);
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSString * errors = [[NSString alloc]initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        DLog(@"failure = %@",errors);
        block(401);
    }];
}

/**
 *  登录第二步 用返回的code请求主后端的登录接口
 *
 *  @param code  code
 *  @param block 返回状态码
 */
+ (void)loginWithCode:(NSString *)code andBlock:(void (^)(NSInteger statusCode))block {
    NSParameterAssert(code);
   
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_login parameters:@{@"code":code} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        DLog(@"sucess data = %@",responseObject);
        block(200);
        [self storeCredentialWihtResponseObject:responseObject];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error = %@",error);
        
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        block(statusCode);

        DLog(@"error code = %ld",(long)statusCode);
        NSString * errors = [[NSString alloc]initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        DLog(@"failure = %@",errors);
    }];

}

/**
 *  储存 accessToken & refreshToken
 *
 *  @param responseObject Dic
 */
+ (void)storeCredentialWihtResponseObject:(NSDictionary *)responseObject {
    
    AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:[responseObject valueForKey:@"accessToken"] tokenType:[responseObject valueForKey:@"token_type"]];
    NSString *refreshToken = [responseObject valueForKey:@"refreshToken"];
    
    if (refreshToken) { // refreshToken is optional in the OAuth2 spec
        [credential setRefreshToken:refreshToken];
    }
    
    // Expiration is optional, but recommended in the OAuth2 spec. It not provide, assume distantFuture === never expires
    NSDate *expireDate = [NSDate distantFuture];
    id expiresIn = [responseObject valueForKey:@"expire"];
    if (expiresIn && ![expiresIn isEqual:[NSNull null]]) {
        expireDate = [NSDate dateWithTimeIntervalSinceNow:[expiresIn doubleValue]];
    }
    
    if (expireDate) {
        [credential setExpiration:expireDate];
    }
    
    //DLog(@"expireDate = %@",expireDate);

    // 存储 access_token
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    [AFOAuthCredential storeCredential:credential withIdentifier:serviceProviderIdentifier];
}

//刷新token
+ (void)validateOAuthWithBlock:(void (^)(NSInteger))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 存在 access_token
        if (!credential.isExpired) {
            DLog(@" access_token & refresh_token 尚未过期")
            // access_token & refresh_token 没有过期
            block(200);
            [self refreshWithToken:credential.refreshToken andBlock:^(NSInteger statusCode) {
                if (statusCode == 200) {
                    //block(200);
                }else {
                    kTipAlert(@"用户身份刷新失败！");
                }
            }];
        } else {
            block(401);//token过期
            kTipAlert(@"用户身份信息已过期！");
            DLog(@" access_token & refresh_token 已经过期");
        }
    } else {
        // 不存在 access_token
        block(404);
    }
    
}

/**
 *  传入服务器返回的refreshToken请求接口 刷新token有效期
 *
 *  @param refreshToken refreshToken
 *  @param block        状态码
 */
+ (void)refreshWithToken:(NSString *)refreshToken andBlock:(void (^)(NSInteger))block {
    NSParameterAssert(refreshToken);
  
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_login parameters:@{@"refreshToken":refreshToken} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        DLog(@"sucess data = %@",responseObject);
        block(200);
        [self storeCredentialWihtResponseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error = %@",error);
        
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        block(statusCode);
        
        /*
         NSString * errors = [[NSString alloc]initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
         DLog(@"error code = %ld",(long)statusCode);
         DLog(@"failure = %@",errors);
         */
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
    DLog(@"退出登录 deleteToken");
    [UserModel removeMyProfile]; //删除用户资料
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
        DLog(@"else");
    }
}

//重置密码
+ (void)postResetPasswordWithPhone:(NSString *)phoneNumber code:(NSString *)code password:(NSString *)password andBlock:(void (^)(NSInteger))block {
    
    NSParameterAssert(phoneNumber);
    NSParameterAssert(password);
    NSParameterAssert(code);
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_reset parameters:@{@"phone": phoneNumber, @"password": password, @"code": code} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(200);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block([operation.response statusCode]);
    }];
}

//修改密码
+ (void)modifyPassword:(NSString *)password newPassword:(NSString *)newPassword andBlock:(void (^)(NSInteger))block {
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
            block([operation.response statusCode]);
        }];
    }
}


+ (void)getMyProfileWithBlock:(void (^)(NSDictionary *responseDictionary))block {

    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则获取用户信息
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_userProfile parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"userModel = %@",responseObject);
            UserModel *userModel = [[UserModel alloc] initWithDictionary:responseObject];
            [userModel storeValueWithKey:@"MyProfile"];

            block(@{@"statusCode": @(200), @"model": userModel});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @(400), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @(401), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        DLog(@"access_token不存在");
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}


@end
