//
//  HttpClient.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/6.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "Login.h"
#import "HttpClient.h"
#import "AFHTTPRequestSerializer+OAuth2.h"
#import "UpYun.h"
#import "AFNetworking.h"

#import "UserManagerCenter.h"
#import "RootViewController.h"
#import "WalletModel.h"
#import "WalletHistoryModel.h"

#pragma mark - 服务器


#define kTimeoutInterval 7.f

#define API_launch @"/user/launch" //启动

#define API_authorise @"/authorise" // authorise
#define API_verifyCode @"/user/code" //获取验证码
#define API_checkCode @"/user/checkCode" //检查短信验证码
#define API_register @"/user/register" //注册
#define API_login @"/user/login" //登录
#define API_reset @"/user/reset" //重置密码
#define API_changePassword @"/user/changePassword" //修改密码
#define API_inviteCode @"/user/inviteCode" //邀请码

#define API_wallet @"/user/wallet"
#define API_walletCharge @"/wallet/charge"
#define API_walletSign @"/wallet/sign/alipay"
#define API_walletHistory @"/wallet/history"
#define API_walletWithDraw @"/wallet/withDraw"



#define API_verify @"/user/verify"
#define API_userProfile @"/user/profile"
#define API_uploadPhoto @"/upload/user"
#define API_config @"/config/ad/"
#define API_activity @"/config/activity"

#define API_Publish_Market_Publish   @"/market/add"

#define API_Search_Market_Search   @"/market/search"

#define API_Buy_market_Buy @"/market/buy"

#define API_Piblish_Supplier_Order @"/order/supplier/add"
#define API_Piblish_Factory_Order  @"/order/factory/add"
#define API_Piblish_Design_Order   @"/order/design/add"

#define API_Search_Supplier_Order @"/order/supplier/search"
#define API_Search_Factory_Order  @"/order/factory/search"
#define API_Search_Design_Order   @"/order/design/search"

#define API_GetIMToken @"/im/token"//获取融云token
#define API_SearchBusiness @"/user/search"

#define kPopular_News_Search @"/api/search"
#define kPopular_News_Top @"/api/getTop"
#define kPopular_News_List @"/api/getList"

#define API_Goods_Buy_History @"/market/buy"
#define API_Goods_Sell_History @"/market/sell"

#define API_Goods_Buy_Wallet @"/wallet/pay/"
@implementation HttpClient

/*User**********************************************************************************************************************************************/


+ (void)iOSLaunchWithDeviceId:(NSString *)deviceId WithClientVersion:(NSString *)clientVersion {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    if (credential) {
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
    }
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_launch parameters:@{@"deviceId": deviceId,@"deviceType": @"iOS",@"clientVersion": clientVersion} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //        DLog(@"User - 启动成功 = 200");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        DLog(@"User - 启动失败 = %ld",(long)statusCode);
    }];
}




+ (void)postVerifyCodeWithPhone:(NSString *)phoneNumber andBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSParameterAssert(phoneNumber);
    if (phoneNumber.length != 11) {
        block(@{@"statusCode": @(400), @"message": @"手机号码格式错误 "});// 手机格式不正确
        return;
    }
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_verifyCode parameters:@{@"phone": phoneNumber} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        DLog(@"responseObject = %@",responseObject);
        block(@{@"statusCode": @(200), @"message": @"发送成功，十分钟内有效 "});
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        DLog(@"获取验证码的statusCode = %ld",(long)statusCode);
        switch (statusCode) {
            case 400:
                block(@{@"statusCode": @(400), @"message": @"手机格式不正确 "});
                break;
            case 409:
                block(@{@"statusCode": @(409), @"message": @"需要等待冷却 "});
                break;
            default:{
                NSString * error = [NSString stringWithFormat:@"发送错误 (错误码:%ld)",(long)statusCode];
                block(@{@"statusCode": @(statusCode), @"message": error});
            }
                break;
        }
    }];
}

+ (void)validateCodeWithPhone:(NSString *)phoneNumber code:(NSString *)code andBlock:(void (^)(NSInteger))block {
    NSParameterAssert(phoneNumber);
    NSParameterAssert(code);
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:API_checkCode parameters:@{@"phone": phoneNumber, @"code": code} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        block(200);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(401);
    }];
    
}

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password UserRole:(NSString *)role code:(NSString *)code UserName:(NSString *)name andBlock:(void (^)(NSDictionary *))block {
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_register parameters:@{@"phone": username, @"password": password,@"code": code, @"role": role, @"name": name} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        block(@{@"statusCode": @(200), @"message": @"注册成功 "});
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        DLog(@"error = %@", error);
        DLog(@"error = %ld",(long)statusCode);
        switch (statusCode) {
            case 401:
                block(@{@"statusCode": @(401), @"message": @"验证码错误 "});
                break;
            case 409:
                block(@{@"statusCode": @(409), @"message": @"该手机已经注册过 "});
                break;
                
            default:
                block(@{@"statusCode": @(statusCode), @"message": @"注册错误 "});
                break;
        }
    }];
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password andBlock:(void (^)(NSInteger))block {
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:[NSURL URLWithString:kAuthUrl] clientID:kClientID secret:kSecret];
    
    [OAuth2Manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    OAuth2Manager.requestSerializer.timeoutInterval = kTimeoutInterval;
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
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        block(statusCode);
        
        DLog(@"statusCode = %ld\nfailure = %@",(long)statusCode,errors);
        
    }];
}

+ (void)loginWithCode:(NSString *)code andBlock:(void (^)(NSInteger statusCode))block {
    NSParameterAssert(code);
    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
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
                    //                    kTipAlert(@"用户身份刷新失败！");
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

+ (void)refreshWithToken:(NSString *)refreshToken andBlock:(void (^)(NSInteger))block {
    NSParameterAssert(refreshToken);
    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_login parameters:@{@"refreshToken":refreshToken} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //        DLog(@"sucess data = %@",responseObject);
        block(200);
        [self storeCredentialWihtResponseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error = %@",error);
        
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        block(statusCode);
        if (statusCode == 500) {
            [RootViewController setupLoginViewController];
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
    DLog(@"退出登录 deleteToken");
    [UserModel removeMyProfile]; //删除用户资料
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    return [AFOAuthCredential deleteCredentialWithIdentifier:serviceProviderIdentifier];
}



//发送邀请码
+ (void)registerWithInviteCode:(NSString *)inviteCode andBlock:(void (^)(NSInteger))block {
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
        [manager PUT:API_inviteCode parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block (200);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"%@",error);
            block ([operation.response statusCode]);
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
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:API_reset parameters:@{@"phone": phoneNumber, @"password": password, @"code": code} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(200);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block([operation.response statusCode]);
    }];
}

//修改密码
+ (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword andBlock:(void (^)(NSInteger))block {
    NSParameterAssert(oldPassword);
    NSParameterAssert(newPassword);
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager PUT:API_changePassword parameters:@{@"oldPassword": oldPassword, @"newPassword": newPassword} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(200);
            DLog(@"200");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block([operation.response statusCode]);
            DLog(@"%ld",[operation.response statusCode]);
            
        }];
    }
}


/**
 *  获取自己的用户信息
 *
 *  @param block 用户模型
 */
+ (void)getMyProfileWithBlock:(void (^)(NSDictionary *responseDictionary))block {
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则获取用户信息
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = kTimeoutInterval;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager GET:API_userProfile parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UserModel *userModel = [[UserModel alloc] initWithDictionary:responseObject];
            [userModel storeValueWithKey:@"MyProfile"];
            //            DLog(@"userModel = %@",responseObject);
            //            DLog(@"userModel.description = %@",userModel.description);
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

+ (void)postMyProfileWithDic:(NSMutableDictionary *)Dic andBlock:(void (^)(NSInteger statusCode))block {
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则获取用户信息
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager    POST:API_userProfile parameters:Dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            DLog(@"修改个人资料 = %@",responseObject);
            block(200);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"123%@",error);
            block([operation.response statusCode]);
        }];
    } else {
        DLog(@"access_token不存在");
        block(404);// access_token不存在
    }
}

/**
 *  获取自己的钱包
 *
 *  @param block 回调函数  200 OK  返回钱包Model
 
 */
+ (void)getwalletWithBlock:(void (^)(NSDictionary *responseDictionary))block {
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则获取用户信息
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_wallet parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"wallet = %@",responseObject);
            
            WalletModel * model = [[WalletModel alloc]initWithDictionary:responseObject];
            [[StoreUserValue sharedInstance] storeValue:model withKey:@"walletModel"];
            block(@{@"statusCode": @(200), @"model": model});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @(400), @"message": @"未登录!"});
                    break;
                case 401:
                    block(@{@"statusCode": @(401), @"message": @"access_token过期或者无效!"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误!"});
                    break;
            }
        }];
    } else {
        DLog(@"access_token不存在");
        block(@{@"statusCode": @404, @"message": @"access_token不存在!"});// access_token不存在
    }
}

+ (void)walletWithFee:(NSString *)fee WihtCharge:(void (^)(NSDictionary *))block{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则获取用户信息
        AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 20.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:API_walletCharge parameters:@{@"fee":fee} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            //            DLog(@"sucess data = %@",responseObject);
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            block(@{@"statusCode": @(200), @"data":dataDic });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
            NSString * errors = [[NSString alloc]initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            switch (statusCode) {
                case 0:
                    block(@{@"statusCode": @(statusCode), @"message":@"暂无网络（错误码：0）" });
                    break;
                    
                case 502:
                    block(@{@"statusCode": @(statusCode), @"message":@"服务器已爆炸（错误码：502）" });
                    break;
                    
                default:
                    block(@{@"statusCode": @(statusCode), @"message":errors });
                    break;
            }
            
        }];
    } else {
        DLog(@"access_token不存在");
        block(@{@"statusCode": @404, @"message": @"access_token不存在!"});// access_token不存在
    }
}


+ (void)walletsignwithOrderSpec:(NSString *)orderSpec andBlock:(void (^)(NSDictionary *))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则获取用户信息
        AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 20.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:API_walletSign parameters:@{@"string":orderSpec} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            DLog(@"responseObject= %@",responseObject);
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            block(@{@"statusCode": @(200), @"data":dataDic });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
            NSString * errors = [[NSString alloc]initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            block(@{@"statusCode": @(statusCode), @"message":errors });
        }];
    } else {
        DLog(@"access_token不存在");
        block(@{@"statusCode": @404, @"message": @"access_token不存在!"});// access_token不存在
    }
}


+ (void)walletHistoryWithPage:(NSNumber *)page WithBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则获取用户信息
        AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 20.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager GET:API_walletHistory parameters:@{@"page":page} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            //            DLog(@"responseObject = %@",responseObject);
            NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
            [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WalletHistoryModel * model = [[WalletHistoryModel alloc]initWithDictionary:obj];
                [array addObject:model];
            }];
            block(@{@"statusCode": @(200), @"ModelArray":array });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
            NSString * errors = [[NSString alloc]initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            block(@{@"statusCode": @(statusCode), @"message":errors });
        }];
    } else {
        DLog(@"access_token不存在");
        block(@{@"statusCode": @404, @"message": @"access_token不存在!"});// access_token不存在
    }
    
}


+ (void)walletWithDrawWithFee:(NSString *)fee WithMethod:(NSString *)method WithAccount:(NSString *)account  andBlock:(void (^)(NSInteger statusCode))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则获取用户信息
        AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 20.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:API_walletWithDraw parameters:@{@"fee":fee, @"method":method, @"account":account} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            block(200);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
            block(statusCode);
        }];
    } else {
        block(404);// access_token不存在
    }
}
/**
 *  上传认证资料
 *
 *  @param enterpriseName    企业名称
 *  @param personName        法人姓名
 *  @param idCard            身份证号
 *  @param enterpriseAddress 企业地址
 *  @param block             返回状态码 200为成功
 */
+ (void)postVerifyWithenterpriseName:(NSString *)enterpriseName withpersonName:(NSString *)personName withidCard:(NSString *)idCard withenterpriseAddress:(NSString *)enterpriseAddress andBlock:(void (^)(NSInteger statusCode))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录
        NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc]initWithCapacity:4];
        if (enterpriseName) {
            [parametersDic setObject:enterpriseName forKey:@"enterpriseName"];
        }
        if (personName) {
            [parametersDic setObject:personName forKey:@"personName"];
        }
        if (idCard) {
            [parametersDic setObject:idCard forKey:@"idCard"];
        }
        if (enterpriseAddress) {
            [parametersDic setObject:enterpriseAddress forKey:@"enterpriseAddress"];
        }
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_verify parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"上传认证资料 = %@",responseObject);
            block(200);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block([operation.response statusCode]);
        }];
    } else {
        DLog(@"access_token不存在");
        //        block(404);// access_token不存在
        block(404);// access_token不存在
    }
}

+ (void)uploadPhotoWithType:(NSString *)type WithImage:(UIImage *)image andBlock:(void (^)(NSInteger))block {
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录
        AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 20.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager GET:API_uploadPhoto parameters:@{@"type":type} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            //            DLog(@"sucess data = %@",responseObject);
            DLog(@"图片上传成功");
            UpYun *upYun = [[UpYun alloc] init];
            upYun.bucket = bucketAPI;//图片测试
            upYun.expiresIn = 600;// 10分钟
            [upYun uploadImage:image policy:[responseObject objectForKey:@"policy"] signature:[responseObject objectForKey:@"signature"]];
            block(200);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
            block(statusCode);
            
            NSString * errors = [[NSString alloc]initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            DLog(@"error code = %ld",(long)statusCode);
            DLog(@"failure = %@",errors);
            //            DLog(@"error = %@",error);
        }];
    } else {
        DLog(@"access_token不存在");
        block(404);// access_token不存在
    }
}

/*Config**********************************************************************************************************************************************/

+ (void)getConfigWithType:(NSString *)type WithBlock:(void (^)(NSDictionary *))block {
    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString * GetUrl = [NSString stringWithFormat:@"%@%@",API_config,type];
    
    [manager GET:GetUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        block(@{@"statusCode": @(200), @"responseArray": responseObject});
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        DLog(@"获取验证码的statusCode = %ld",(long)statusCode);
        block(@{@"statusCode": @(statusCode)});
    }];
}
+ (void)getActivityWithBlock:(void (^)(NSDictionary *responseDictionary))block {
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:API_activity parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        block(@{@"statusCode": @(200), @"responseArray": responseObject});
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        DLog(@"获取验证码的statusCode = %ld",(long)statusCode);
        block(@{@"statusCode": @(statusCode)});
    }];
    
}
// 获取用户评论
+ (void)getUserCommentWithUserID:(NSString *)aUserID page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/user/comment/",aUserID];
        [manager GET:urlString parameters:@{@"page":aPage} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            // DLog(@"responseObject == %@",responseObject);
            NSArray *array = responseObject;
            NSMutableArray *dataArray = [@[] mutableCopy];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                DealComment_Model *model = [DealComment_Model getDealCommentModelWithDictionary:dic];
                [dataArray addObject:model];
            }];
            completionBlock(@{@"statusCode":@200,@"message":dataArray});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 获取他人信息
+ (void)getOtherIndevidualsInformationWithUserID:(NSString *)userID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/user/profile/",userID];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //DLog(@"responseObject == %@",responseObject);
            OthersUserModel *model = [[OthersUserModel alloc] initWithDictionary:responseObject];
            completionBlock(@{@"statusCode":@200,@"message":model});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
}




// 发布设计（店铺）
+ (void)publishDesignWithMarket:(NSString *)aMarket name:(NSString *)aName type:(NSString *)aType part:(NSString *)aPart price:(NSString *)aPrice marketPrice:(NSString *)aMarketPrice country:(NSString *)aCountry amount:(NSString *)aAmount description:(NSString *)aDescription category:(NSArray *)aCategory WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aMarket) {
            [parametersDictionary setObject:aMarket forKey:@"market"];
        }
        if (aName) {
            [parametersDictionary setObject:aName forKey:@"name"];
        }
        if (aCountry) {
            [parametersDictionary setObject:aCountry forKey:@"country"];
        }
        if (aType) {
            [parametersDictionary setObject:aType forKey:@"type"];
        }
        if (aPart) {
            [parametersDictionary setObject:aPart forKey:@"part"];
        }
        if (aPrice) {
            [parametersDictionary setObject:aPrice forKey:@"price"];
        }
        if (aMarketPrice) {
            [parametersDictionary setObject:aMarketPrice forKey:@"marketPrice"];
        }
        if (aAmount) {
            [parametersDictionary setObject:aAmount forKey:@"amount"];
        }
        
        if (aDescription) {
            [parametersDictionary setObject:aDescription forKey:@"description"];
        }
        if (aCategory) {
            [parametersDictionary setObject:aCategory forKey:@"category"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_Publish_Market_Publish parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            completionBlock(@{@"statusCode": @([operation.response statusCode]), @"responseObject":responseObject});
            //            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            completionBlock(@{@"statusCode": @([operation.response statusCode])});
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}


// 发布面料（市场）
+ (void)publishFabricWithMarket:(NSString *)aMarket name:(NSString *)aName type:(NSString *)aType price:(NSString *)aPrice marketPrice:(NSString *)aMarketPrice amount:(NSString *)aAmount unit:(NSString *)aUnit description:(NSString *)aDescription category:(NSArray *)aCategory WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aMarket) {
            [parametersDictionary setObject:aMarket forKey:@"market"];
        }
        if (aName) {
            [parametersDictionary setObject:aName forKey:@"name"];
        }
        if (aType) {
            [parametersDictionary setObject:aType forKey:@"type"];
        }
        if (aPrice) {
            [parametersDictionary setObject:aPrice forKey:@"price"];
        }
        if (aMarketPrice) {
            [parametersDictionary setObject:aMarketPrice forKey:@"marketPrice"];
        }
        
        if (aAmount) {
            [parametersDictionary setObject:aAmount forKey:@"amount"];
        }
        if (aUnit) {
            [parametersDictionary setObject:aUnit forKey:@"unit"];
        }
        
        if (aDescription) {
            [parametersDictionary setObject:aDescription forKey:@"description"];
        }
        if (aCategory) {
            [parametersDictionary setObject:aCategory forKey:@"category"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_Publish_Market_Publish parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            completionBlock(@{@"statusCode": @([operation.response statusCode]), @"responseObject":responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            completionBlock(@{@"statusCode": @([operation.response statusCode])});
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}


// 搜索设计（市场）
+ (void)searchDesignWithMarket:(NSString *)aMarket type:(NSString *)aType part:(NSString *)aPart price:(NSString *)aPrice priceOrder:(NSString *)aPriceOrder keyword:(NSString *)aKeyword province:(NSString *)aProvince city:(NSString *)aCity country:(NSString *)aCountry aCreatedAt:(NSString *)aCreatedAt page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aMarket) {
            [parametersDictionary setObject:aMarket forKey:@"market"];
        }
        if (aType) {
            [parametersDictionary setObject:aType forKey:@"type"];
        }
        if (aPrice) {
            [parametersDictionary setObject:aPrice forKey:@"price"];
        }
        if (aPriceOrder) {
            [parametersDictionary setObject:aPriceOrder forKey:@"priceOrder"];
        }
        if (aPart) {
            [parametersDictionary setObject:aPart forKey:@"part"];
        }
        if (aKeyword) {
            [parametersDictionary setObject:aKeyword forKey:@"keyword"];
        }
        if (aProvince) {
            [parametersDictionary setObject:aProvince forKey:@"province"];
        }
        if (aCity) {
            [parametersDictionary setObject:aCity forKey:@"city"];
        }
        if (aCountry) {
            [parametersDictionary setObject:aCountry forKey:@"country"];
        }
        if (aCreatedAt) {
            [parametersDictionary setObject:aCreatedAt forKey:@"createdAt"];
        }
        if (aPage) {
            [parametersDictionary setObject:aPage forKey:@"page"];
        }
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_Search_Market_Search parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            completionBlock(@{@"statusCode": @"200", @"message": responseObject});
            //            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}


// 搜索面料、辅料、机械设备（商城）
+ (void)searchFabricWithMarket:(NSString *)aMarket type:(NSString *)aType price:(NSString *)aPrice priceOrder:(NSString *)aPriceOrder keyword:(NSString *)aKeyword province:(NSString *)aProvince city:(NSString *)aCity page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aMarket) {
            [parametersDictionary setObject:aMarket forKey:@"market"];
        }
        if (aType) {
            [parametersDictionary setObject:aType forKey:@"type"];
        }
        if (aPrice) {
            [parametersDictionary setObject:aPrice forKey:@"price"];
        }
        if (aPriceOrder) {
            [parametersDictionary setObject:aPriceOrder forKey:@"priceOrder"];
        }
        if (aProvince) {
            [parametersDictionary setObject:aProvince forKey:@"province"];
        }
        if (aKeyword) {
            [parametersDictionary setObject:aKeyword forKey:@"keyword"];
        }
        if (aCity) {
            [parametersDictionary setObject:aCity forKey:@"city"];
        }
        if (aPage) {
            [parametersDictionary setObject:aPage forKey:@"page"];
        }
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_Search_Market_Search parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            completionBlock(@{@"statusCode": @"200", @"message": responseObject});
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 获取面料详情
+ (void)getFabricDetailWithId:(NSString *)aID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/market/",aID];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            FabricMarketModel *marketModel = [FabricMarketModel getFabricMarketModelWithDictionary:responseObject];
            // DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"model": marketModel});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            completionBlock(@{@"statusCode": @([operation.response statusCode]), @"model": @"请求失败"});
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 商家汇总（找合作商，找厂家）
+ (void)searchBusinessWithRole:(NSString *)aRole scale:(NSString *)aScale province:(NSString *)aProvince city:(NSString *)aCity subRole:(NSString *)aSubRole keyWord:(NSString *)aKeyWord verified:(NSString *)aVerified page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aRole) {
            [parametersDictionary setObject:aRole forKey:@"role"];
        }
        if (aScale) {
            [parametersDictionary setObject:aScale forKey:@"scale"];
        }
        if (aProvince) {
            [parametersDictionary setObject:aProvince forKey:@"province"];
        }
        if (aCity) {
            [parametersDictionary setObject:aCity forKey:@"city"];
        }
        if (aSubRole) {
            [parametersDictionary setObject:aSubRole forKey:@"subRole"];
        }
        if (aKeyWord) {
            [parametersDictionary setObject:aKeyWord forKey:@"keyword"];
        }
        if (aVerified) {
            [parametersDictionary setObject:aVerified forKey:@"verified"];
        }
        if (aPage) {
            [parametersDictionary setObject:aPage forKey:@"page"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_SearchBusiness parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            // DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"message":responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
        
    }else{
        completionBlock(@{@"statusCode": @"404", @"message": @"token不存在"});
    }
}

// 发布供应商订单
+ (void)publishSupplierOrderWithType:(NSString *)aType name:(NSString *)aName amount:(NSString *)aAmount unit:(NSString *)aUnit description:(NSString *)aDescription WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aType) {
            [parametersDictionary setObject:aType forKey:@"type"];
        }
        if (aName) {
            [parametersDictionary setObject:aName forKey:@"name"];
        }
        if (aAmount) {
            [parametersDictionary setObject:aAmount forKey:@"amount"];
        }
        if (aUnit) {
            [parametersDictionary setObject:aUnit forKey:@"unit"];
        }
        if (aDescription) {
            [parametersDictionary setObject:aDescription forKey:@"description"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_Piblish_Supplier_Order parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //            DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"message":responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
        
    }else{
        completionBlock(@{@"statusCode": @"404", @"message": @"token不存在"});
    }
}

// 发布找工厂订单
+ (void)publishFactoryOrderWithSubrole:(NSString *)aSubrole type:(NSString *)aType amount:(NSString *)aAmount deadline:(NSString *)aDeadline description:(NSString *)aDescription credit:(NSString *)aCredit WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aSubrole) {
            [parametersDictionary setObject:aSubrole forKey:@"subRole"];
        }
        if (aType) {
            [parametersDictionary setObject:aType forKey:@"type"];
        }
        if (aAmount) {
            [parametersDictionary setObject:aAmount forKey:@"amount"];
        }
        if (aDeadline) {
            [parametersDictionary setObject:aDeadline forKey:@"deadline"];
        }
        if (aDescription) {
            [parametersDictionary setObject:aDescription forKey:@"description"];
        }
        if (aCredit) {
            [parametersDictionary setObject:aCredit forKey:@"credit"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_Piblish_Factory_Order parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            // DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"message":responseObject});
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
            completionBlock(@{@"statusCode": [NSString stringWithFormat:@"%ld",(long)statusCode]});
        }];
        
    }else{
        completionBlock(@{@"statusCode": @"404", @"message": @"token不存在"});
    }
    
}

// 发布设计商订单
+ (void)publishDesignOrderWithName:(NSString *)aName description:(NSString *)aDescription WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aName) {
            [parametersDictionary setObject:aName forKey:@"name"];
        }
        if (aDescription) {
            [parametersDictionary setObject:aDescription forKey:@"description"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_Piblish_Design_Order parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //  DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"message":responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
}

// 搜索供应商订单
+ (void)searchSupplierOrderWithKeyword:(NSString *)aKeyword type:(NSString *)aType pageCount:(NSNumber *)aPageCount WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aKeyword) {
            [parametersDictionary setObject:aKeyword forKeyedSubscript:@"keyword"];
        }
        if (aType) {
            [parametersDictionary setObject:aType forKeyedSubscript:@"type"];
        }
        if (aPageCount) {
            [parametersDictionary setObject:aPageCount forKeyedSubscript:@"page"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_Search_Supplier_Order parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"responseObject == %@",responseObject);
            NSArray *responseArray = (NSArray *)responseObject;
            NSMutableArray *array = [@[] mutableCopy];
            [responseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dictionary = (NSDictionary *)obj;
                SupplierOrderModel *model = [SupplierOrderModel getSupplierOrderModelWithDictionary:dictionary];
                [array addObject:model];
            }];
            completionBlock(@{@"statusCode": @"200", @"message":array});
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
}

// 搜索找工厂订单
+ (void)searchFactoryOrderWithKeyword:(NSString *)aKeyword type:(NSString *)aType amount:(NSArray *)aAmount deadline:(NSString *)aDeadline pageCount:(NSNumber *)aPageCount WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aKeyword) {
            [parametersDictionary setObject:aKeyword forKeyedSubscript:@"keyword"];
        }
        if (aType) {
            [parametersDictionary setObject:aType forKeyedSubscript:@"subRole"];
        }
        if (aAmount) {
            [parametersDictionary setObject:aAmount forKeyedSubscript:@"amount"];
        }
        if (aDeadline) {
            [parametersDictionary setObject:aDeadline forKeyedSubscript:@"deadline"];
        }
        if (aPageCount) {
            [parametersDictionary setObject:aPageCount forKeyedSubscript:@"page"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_Search_Factory_Order parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //DLog(@"responseObject == %@",responseObject);
            NSArray *responseArray = (NSArray *)responseObject;
            NSMutableArray *array = [@[] mutableCopy];
            [responseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dictionary = (NSDictionary *)obj;
                FactoryOrderMOdel *model = [FactoryOrderMOdel getSupplierOrderModelWithDictionary:dictionary];
                [array addObject:model];
            }];
            completionBlock(@{@"statusCode": @"200", @"message":array});
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 搜索设计商订单
+ (void)searchDesignOrderWithKeyword:(NSString *)aKeyword pageCount:(NSNumber *)aPageCount WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aKeyword) {
            [parametersDictionary setObject:aKeyword forKeyedSubscript:@"keyword"];
        }
        if (aPageCount) {
            [parametersDictionary setObject:aPageCount forKeyedSubscript:@"page"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_Search_Design_Order parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //DLog(@"responseObject == %@",responseObject);
            NSArray *responseArray = (NSArray *)responseObject;
            NSMutableArray *array = [@[] mutableCopy];
            [responseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dictionary = (NSDictionary *)obj;
                DesignOrderModel *model = [DesignOrderModel getDesignOrderModelWithDictionary:dictionary];
                [array addObject:model];
            }];
            completionBlock(@{@"statusCode": @"200", @"message":array});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 获取供应商订单详情
+ (void)getSupplierOrderDetailWithID:(NSString *)aID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/supplier/",aID];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"responseObject == %@",responseObject);
            completionBlock(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 获取找工厂订单详情
+ (void)getFactoryOrderDetailWithID:(NSString *)aID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/factory/",aID];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            // DLog(@"responseObject == %@",responseObject);
            completionBlock(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 获取设计商订单详情
+ (void)getDesignOrderDetailWithID:(NSString *)aID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/design/",aID];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"responseObject == %@",responseObject);
            completionBlock(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 投标工厂订单
+ (void)bidFactoryOrderWithDiscription:(NSString *)aDiscription orderID:(NSString *)aOrderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aDiscription) {
            [parametersDictionary setObject:aDiscription forKeyedSubscript:@"description"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/factory/bid/",aOrderID];
        [manager POST:urlString parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"message":responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
            completionBlock(@{@"statusCode": [NSString stringWithFormat:@"%ld",(long)statusCode]});
            DLog(@"%@",error.userInfo);
            DLog(@">>>>%@",operation);
        }];
    }else{
        completionBlock(@{@"statusCode": @"404", @"message": @"token不存在"});
    }
}

// 投标供应商订单
+ (void)bidSupplierOrderWithPrice:(NSString *)aPrice source:(NSString *)aSource discription:(NSString *)aDiscription orderID:(NSString *)aOrderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aDiscription) {
            [parametersDictionary setObject:aDiscription forKeyedSubscript:@"description"];
        }
        if (aPrice) {
            [parametersDictionary setObject:aPrice forKeyedSubscript:@"price"];
        }
        if (aSource) {
            [parametersDictionary setObject:aSource forKeyedSubscript:@"source"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/supplier/bid/",aOrderID];
        [manager POST:urlString parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"message":responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 投标设计订单
+ (void)bidDesignerOrderWithDiscription:(NSString *)aDiscription orderID:(NSString *)aOrderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aDiscription) {
            [parametersDictionary setObject:aDiscription forKeyedSubscript:@"description"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/design/bid/",aOrderID];
        [manager POST:urlString parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"message":responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 获取供应订单竞标用户
+ (void)getSupplierOrderBidUserAmountWithOrderID:(NSString *)aOrderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/supplier/bid/",aOrderID];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            // DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @(200), @"message": responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 获取工厂订单竞标用户
+ (void)getFactoryOrderBidUserAmountWithOrderID:(NSString *)aOrderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/factory/bid/",aOrderID];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            // DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @(200), @"message": responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 获取设计订单竞标用户
+ (void)getDesignOrderBidUserAmountWithOrderID:(NSString *)aOrderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/design/bid/",aOrderID];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @(200), @"message": responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 获取所有用户有关的订单
+ (void)getAllMyOrdersWithOrderStatus:(NSString *)aStatus page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aStatus) {
            [parametersDictionary setObject:aStatus forKeyedSubscript:@"status"];
        }
        if (aPage) {
            [parametersDictionary setObject:aPage forKeyedSubscript:@"page"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = @"/order/myAll";
        [manager GET:urlString parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            // DLog(@"responseObject == %@",responseObject);
            NSArray *responseArray = (NSArray *)responseObject;
            NSMutableArray *array = [@[] mutableCopy];
            [responseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dictionary = (NSDictionary *)obj;
                ProcessingAndComplitonOrderModel *model = [ProcessingAndComplitonOrderModel getProcessingAndComplitonOrderModelWithDictionary:dictionary];
                [array addObject:model];
            }];
            completionBlock(@{@"statusCode": @"200", @"message":array});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 关闭订单
+ (void)closeSupplierOrderWithOrderID:(NSString *)aOrderID winnerUserID:(NSString *)aWinnerUserID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aWinnerUserID) {
            [parametersDictionary setObject:aWinnerUserID forKeyedSubscript:@"winner"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/supplier/close/",aOrderID];
        [manager POST:urlString parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"message": responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
}

// 关闭工厂订单
+ (void)closeFactoryOrderWithOrderID:(NSString *)aOrderID winnerUserID:(NSString *)aWinnerUserID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aWinnerUserID) {
            [parametersDictionary setObject:aWinnerUserID forKeyedSubscript:@"winner"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/factory/close/",aOrderID];
        [manager POST:urlString parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"message": responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 关闭设计订单
+ (void)closeDesignOrderWithOrderID:(NSString *)aOrderID winnerUserID:(NSString *)aWinnerUserID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aWinnerUserID) {
            [parametersDictionary setObject:aWinnerUserID forKeyedSubscript:@"winner"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/design/close/",aOrderID];
        [manager POST:urlString parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"message": responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
}

// 评价供应商订单
+ (void)judgeSupplierOrderWithOrderID:(NSString *)aOrderID score:(NSString *)aScore comment:(NSString *)aComment WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aScore) {
            [parametersDictionary setObject:aScore forKeyedSubscript:@"score"];
        }
        if (aComment) {
            [parametersDictionary setObject:aComment forKeyedSubscript:@"comment"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/supplier/rate/",aOrderID];
        [manager PATCH:urlString parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"message": responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 评价工厂订单
+ (void)judgeFactoryOrderWithOrderID:(NSString *)aOrderID score:(NSString *)aScore comment:(NSString *)aComment WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aScore) {
            [parametersDictionary setObject:aScore forKeyedSubscript:@"score"];
        }
        if (aComment) {
            [parametersDictionary setObject:aComment forKeyedSubscript:@"comment"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/factory/rate/",aOrderID];
        [manager PATCH:urlString parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            // DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"message": responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
    
}

// 评价设计订单
+ (void)judgeDesignOrderWithOrderID:(NSString *)aOrderID score:(NSString *)aScore comment:(NSString *)aComment WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aScore) {
            [parametersDictionary setObject:aScore forKeyedSubscript:@"score"];
        }
        if (aComment) {
            [parametersDictionary setObject:aComment forKeyedSubscript:@"comment"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/design/rate/",aOrderID];
        [manager PATCH:urlString parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            // DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"200", @"message": responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 签署协议
+ (void)signContractWithName:(NSString *)name fee:(NSString *)fee amount:(NSString *)amount delivery:(NSString *)delivery deadline:(NSString *)deadline  address:(NSString *)address  carriage:(NSString *)carriage  payStartDate:(NSString *)payStartDate  payStartFee:(NSString *)payStartFee  payEndDate:(NSString *)payEndDate  payEndDay:(NSString *)payEndDay orderID:(NSString *)orderID preview:(NSString *)preview WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (name) {
            [parametersDictionary setObject:name forKeyedSubscript:@"name"];
        }
        if (fee) {
            [parametersDictionary setObject:fee forKeyedSubscript:@"fee"];
        }
        if (amount) {
            [parametersDictionary setObject:amount forKeyedSubscript:@"amount"];
        }
        if (delivery) {
            [parametersDictionary setObject:delivery forKeyedSubscript:@"delivery"];
        }
        if (deadline) {
            [parametersDictionary setObject:deadline forKeyedSubscript:@"deadline"];
        }
        if (address) {
            [parametersDictionary setObject:address forKeyedSubscript:@"address"];
        }
        if (carriage) {
            [parametersDictionary setObject:carriage forKeyedSubscript:@"carriage"];
        }
        if (payStartDate) {
            [parametersDictionary setObject:payStartDate forKeyedSubscript:@"payStartDate"];
        }
        if (payStartFee) {
            [parametersDictionary setObject:payStartFee forKeyedSubscript:@"payStartFee"];
        }
        if (payEndDate) {
            [parametersDictionary setObject:payEndDate forKeyedSubscript:@"payEndDate"];
        }
        if (payEndDay) {
            [parametersDictionary setObject:payEndDay forKeyedSubscript:@"payEndDay"];
        }
        if (preview) {
            [parametersDictionary setObject:preview forKeyedSubscript:@"preview"];
        }
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/factory/contract/",orderID];
        [manager PUT:urlString parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"responseObject == %@",responseObject);
            completionBlock(@{@"statusCode": @"500", @"message": responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSData *data = [[NSData alloc] init];
            data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            DLog(@"data == %@",data);
            
            completionBlock(@{@"statusCode": @"200", @"message": data});
        }];
    }else{
        completionBlock(@{@"statusCode": @"404", @"message": @"token不存在"});
    }
}

// 获取合同图片
+ (void)getContractImageWithOrderID:(NSString *)orderID WithCompletionBlock:(void(^)(UIImage *image))completionBlock{
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manger.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/factory/contract/",orderID];
        [manger GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            DLog(@">>>>>>>>>>%@",responseObject);
            completionBlock(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"++++++++++%@",error);
            
        }];
    }
}

// 加工厂同意签署协议
+ (void)factorySignContractWithOrderID:(NSString *)orderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manger.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/factory/contract/",orderID];
        [manger PATCH:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            DLog(@">>>>>>>>>>%@",responseObject);
            completionBlock(@{@"statusCode":@"200"});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"++++++++++%@",error);
            completionBlock(@{@"statusCode":@"500"});
        }];
    }else{
        completionBlock(@{@"statusCode":@"404"});
    }
    
}

// 添加订单进度消息
+ (void)addOrderMessageWithOrderID:(NSString *)orderID message:(NSString *)message WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manger.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/factory/message/",orderID];
        [manger POST:urlString parameters:@{@"message":message} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            DLog(@">>>>>>>>>>%@",responseObject);
            
            completionBlock(@{@"statusCode":@"200"});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"++++++++++%@",error);
            
        }];
        
    }else{
        completionBlock(@{@"statusCode":@"404"});
    }
}

// 获取订单进度消息
+ (void)getOrderMessageWithOrderID:(NSString *)orderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manger.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/factory/message/",orderID];
        [manger GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSArray *array = (NSArray *)responseObject;
            NSMutableArray *responseArray = [@[] mutableCopy];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dictionary = (NSDictionary *)obj;
                NSString *string = [NSString stringWithFormat:@"[%@] %@ %@",dictionary[@"user"],dictionary[@"message"],dictionary[@"createdAt"]];
                [responseArray addObject:string];
            }];
            //DLog(@">>>>>>>>>>%@",responseObject);
            completionBlock(@{@"statusCode":@"200",@"message":responseArray});
            //completionBlock(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"++++++++++%@",error);
            completionBlock(@{@"statusCode":@"500",@"message":@""});
        }];
        
    }else{
        completionBlock(@{@"statusCode":@"404"});
    }
}

// 首款支付
+ (void)payFirstWithOrderID:(NSString *)orderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manger.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/factory/firstPay/",orderID];
        [manger GET:urlString parameters:@{@"payment":@"wallet"} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"%@",responseObject);
            completionBlock(@{@"statusCode":@"200"});
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
            NSString *string = [NSString stringWithFormat:@"%ld",(long)statusCode];
            completionBlock(@{@"statusCode":string});
            DLog(@"%@",error);

        }];
        
    }else{
        completionBlock(@{@"statusCode":@"404"});
    }
}

// 限制订单完成
+ (void)finishRestrictOrderWithOrderID:(NSString *)orderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manger.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/order/factory/finish/",orderID];
        [manger PATCH:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"%@",responseObject);
            completionBlock(@{@"statusCode":@"200"});
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
            NSString *string = [NSString stringWithFormat:@"%ld",(long)statusCode];
            completionBlock(@{@"statusCode":string});
            DLog(@"%@",error);
            
        }];
        
    }else{
        completionBlock(@{@"statusCode":@"404"});
    }

}


// 获取店铺
+ (void)getUserShopWithUserID:(NSString *)aUserID page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manger.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/market/shop/",aUserID];
        
        [manger GET:urlString parameters:@{@"page":aPage} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"responseObject == %@",responseObject);
            NSArray *array = responseObject;
            NSMutableArray *dataArray = [@[] mutableCopy];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                PersonalShop_Model *model = [PersonalShop_Model getPersonalShopModelWithDictionary:dic];
                [dataArray addObject:model];
            }];
            completionBlock(@{@"statusCode": @"200", @"message": dataArray});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

//删除店铺里的商品
+ (void)deleteUserShopWithShopID:(NSString *)aShopID withCompletionBlock:(void(^)(int statusCode))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@%@", @"/market/", aShopID];
        [manager DELETE:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((int)[operation.response statusCode]);
        }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    block((int)[operation.response statusCode]);
                    DLog(@"error%@",error);
                }];
    }
    else {
        block(404);// access_token不存在
    }
    
}

//获取认证信息
+ (void)getVerifyWithBlock:(void (^)(NSDictionary *responseDictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录则获取用户信息
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_userProfile parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"userModel = %@",responseObject);
            block(@{@"statusCode": @(200), @"dictionary": responseObject});
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
+ (void)postVerifyWithenterpriseName:(NSString *)enterpriseName withenterpriseAddress:(NSString *)enterpriseAddress withpersonName:(NSString *)personName withidCard:(NSString *)idCard idCardImage:(UIImage *)idCardImage idCardBackImage:(UIImage *)idCardBackImage licenseImage:(UIImage *)licenseImage andBlock:(void (^)(NSInteger statusCode))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        // 已经登录
        NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc]initWithCapacity:4];
        if (enterpriseName) {
            [parametersDic setObject:enterpriseName forKey:@"enterpriseName"];
        }
        if (personName) {
            [parametersDic setObject:personName forKey:@"personName"];
        }
        if (idCard) {
            [parametersDic setObject:idCard forKey:@"idCard"];
        }
        if (enterpriseAddress) {
            [parametersDic setObject:enterpriseAddress forKey:@"enterpriseAddress"];
        }
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 20.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager POST:API_verify parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"上传认证资料 = %@",responseObject);
            DLog(@"idCardImage = %@, idCardBackImage = %@, licenseImage = %@", idCardImage, idCardBackImage, licenseImage);
            block(200);
            DLog(@"%@    %@", responseObject[@"data"][@"idCard"][@"policy"], responseObject[@"data"][@"idCard"][@"signature"]);
            UpYun *upYun1 = [[UpYun alloc] init];
            upYun1.bucket = bucketAPI;//图片测试
            upYun1.expiresIn = 600;// 10分钟
            [upYun1 uploadImage:idCardImage policy:responseObject[@"data"][@"idCard"][@"policy"] signature:responseObject[@"data"][@"idCard"][@"signature"]];
            
            [upYun1 uploadImage:idCardBackImage policy:responseObject[@"data"][@"idCardBack"][@"policy"] signature:responseObject[@"data"][@"idCardBack"][@"signature"]];
            
            [upYun1 uploadImage:licenseImage policy:responseObject[@"data"][@"license"][@"policy"] signature:responseObject[@"data"][@"license"][@"signature"]];
            DLog(@"图片上传成功");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block([operation.response statusCode]);
        }];
    } else {
        DLog(@"access_token不存在");
        //        block(404);// access_token不存在
        block(404);// access_token不存在
    }
    
}

+ (void)uploadPhotoWithPhoto:(UIImage *)photo WithPolicy:(NSString *)policy WithSignature:(NSString *)signature andBlock:(void (^)(NSInteger))block {
    UpYun *upYun1 = [[UpYun alloc] init];
    upYun1.bucket = bucketAPI;//图片测试
    upYun1.expiresIn = 600;// 10分钟
    [upYun1 uploadImage:photo policy:policy signature:signature];
    block(200);
}
+ (void)getIMTokenWithBlock:(void (^)(NSDictionary *))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        [manager GET:API_GetIMToken parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *token = responseObject[@"data"][@"token"];
            block(@{@"statusCode": @([operation.response statusCode]), @"IMToken": token});
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
    
    
}
// 获取店铺(我的店铺)
+ (void)getMyShopWithUserID:(NSString *)aUserID page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manger.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/market/shop/",aUserID];
        
        [manger GET:urlString parameters:@{@"page":aPage} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            completionBlock(@{@"statusCode": @"200", @"message": responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
}
//获取搜索内容
+ (void)searchPopularNewsWithKeyword:(NSString *)keyWord WithBlock:(void (^)(NSDictionary *dictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *url = [NSString stringWithFormat:@"%@%@", kPopularBaseUrl, kPopular_News_Search];
        NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [manager GET:urlString parameters:@{@"keyword":keyWord} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"^^^^^^^^^^^^%@", responseObject);
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseObject});
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": @"没有数据"});
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
    
}
//获取两篇置顶文章
+ (void)getPopularNewsWithBlock:(void (^)(NSDictionary *dictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *urlString = [NSString stringWithFormat:@"%@%@", kPopularBaseUrl, kPopular_News_Top];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"^^^^^^^^^^^^%@", responseObject);
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseObject});
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
}
//随机获取六篇文章
+ (void)getSixPopularNewsListWithCategory:(NSInteger)category withBlock:(void (^)(NSDictionary *dictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString *urlString = [NSString stringWithFormat:@"%@%@", kPopularBaseUrl, kPopular_News_List];
        //        NSString*token = credential.accessToken;
        [manager GET:urlString parameters:@{@"category":[NSString stringWithFormat:@"%ld", category]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            DLog(@"^^^^^^^^^^^^%@", responseObject);
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseObject});
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error = %@", error);
            block(@{@"statusCode": @([operation.response statusCode])});
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
    
}

//买买买
+ (void)buyGoodsWithDictionary:(NSData *)addressDic WithBlock:(void(^)(NSDictionary *dictionary))block {
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_Buy_market_Buy parameters:addressDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            block(@{@"statusCode": @([operation.response statusCode]), @"responseObject":responseObject});
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            block(@{@"statusCode": @([operation.response statusCode]), @"message": error});
        }];
        
    }else{
        //        block(@{@"statusCode": @(410), @"message": @"token不存在"});
    }
    
}

//购买记录
+ (void)getMyGoodsBuyHistoryWithPage:(NSNumber *)aPage WithBlock:(void(^)(NSDictionary *dictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        //        NSString*token = credential.accessToken;
        [manager GET:API_Goods_Buy_History parameters:@{@"page":aPage} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"^^^^^^^^^^^^%@", responseObject);
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseObject});
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
    
    
}
//出售记录
+ (void)getMyGoodsSellHistoryWithPage:(NSNumber *)aPage WithBlock:(void(^)(NSDictionary *dictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        //        NSString*token = credential.accessToken;
        [manager GET:API_Goods_Sell_History parameters:@{@"page":aPage} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"^^^^^^^^^^^^%@", responseObject);
            block(@{@"statusCode": @([operation.response statusCode]), @"responseArray": responseObject});
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            switch ([operation.response statusCode]) {
                case 400:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"未登录"});
                    break;
                case 401:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"access_token过期或者无效"});
                    break;
                    
                default:
                    block(@{@"statusCode": @([operation.response statusCode]), @"message": @"网络错误"});
                    break;
            }
        }];
    } else {
        block(@{@"statusCode": @404, @"message": @"access_token不存在"});// access_token不存在
    }
    
}

//立即拍下
+ (void)getMallOrderWithDictionary:(NSData *)mallOrderDic withBlock:(void(^)(NSDictionary *dictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 20.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager POST:API_Buy_market_Buy parameters:mallOrderDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            DLog(@"responseObject= %@",responseObject);
            block(@{@"statusCode": @(200), @"data":responseObject });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
            NSString * errors = [[NSString alloc]initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            block(@{@"statusCode": @(statusCode), @"message":errors });
        }];
    }
}
//查看购买记录
+ (void)getMallOrderOfBuyWithStatus:(NSString *)aStatus page:(NSNumber *)aPage WithBlock:(void(^)(NSDictionary *dictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 20.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        NSMutableDictionary *mallOrderBuyDic = [NSMutableDictionary dictionaryWithCapacity:0];
        if (aStatus) {
            [mallOrderBuyDic setObject:aStatus forKey:@"status"];
        }
        if (aPage) {
            [mallOrderBuyDic setObject:aPage forKey:@"page"];
        }
        [manager GET:API_Buy_market_Buy parameters:mallOrderBuyDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            DLog(@"responseObject= %@",responseObject);
            block(@{@"statusCode": @(200), @"data":responseObject });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
            NSString * errors = [[NSString alloc]initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            block(@{@"statusCode": @(statusCode), @"message":errors });
        }];
    }

}

//商城付款
+ (void)buyGoodsWithPurchaseId:(NSString *)purchaseId payment:(NSString *)payment WithBlock:(void(^)(NSDictionary *dictionary))block {
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 20.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        NSString *buyString = [NSString stringWithFormat:@"%@%@", API_Goods_Buy_Wallet, purchaseId];
        NSMutableDictionary *goodsBuyDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [goodsBuyDic setObject:payment forKey:@"payment"];
        [manager PATCH:buyString parameters:goodsBuyDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            DLog(@"responseObject= %@",responseObject);
            block(@{@"statusCode": @(200), @"data":responseObject });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
            NSString * errors = [[NSString alloc]initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            block(@{@"statusCode": @(statusCode), @"message":errors });
        }];
    }


}


@end
