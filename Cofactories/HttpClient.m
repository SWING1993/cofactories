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
#import "RootViewController.h"
#import "WalletModel.h"

#pragma mark - 服务器

#define kClientID @"123"
#define kSecret @"123"

#define API_authorise @"/authorise" // authorise
#define API_verifyCode @"/user/code" //获取验证码
#define API_checkCode @"/user/checkCode" //检查短信验证码
#define API_register @"/user/register" //注册
#define API_login @"/user/login" //登录
#define API_reset @"/user/reset"
#define API_modifyPassword @"/user/password"
#define API_wallet @"/user/wallet"
#define API_verify @"/user/verify"
#define API_userProfile @"/user/profile"
#define API_uploadPhoto @"/upload/user"
#define API_config @"/config/ad/:"

#define API_Publish_Machine_Market   @"/market/machine/add"
#define API_Publish_Design_Market    @"/market/design/add"
#define API_Publish_Accessory_Market @"/market/accessory/add"
#define API_Publish_Fabric_Market    @"/market/fabric/add"

#define API_Search_Machine_Market   @"/market/machine/Search"
#define API_Search_Design_Market    @"/market/design/Search"
#define API_Search_Accessory_Market @"/market/accessory/Search"
#define API_Search_Fabric_Market    @"/market/fabric/Search"

#define API_Piblish_Supplier_Order @"/order/supplier/add"
#define API_Piblish_Factory_Order  @"/order/factory/add"
#define API_Piblish_Design_Order   @"/order/design/add"

#define API_Search_Supplier_Order @"/order/supplier/search"
#define API_Search_Factory_Order  @"/order/factory/search"
#define API_Search_Design_Order   @"/order/design/search"

@implementation HttpClient

/*User**********************************************************************************************************************************************/

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
    
    [manager POST:API_verifyCode parameters:@{@"phone": phoneNumber} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        DLog(@"responseObject = %@",responseObject);
        block(@{@"statusCode": @(200), @"message": @"发送成功，十分钟内有效！"});
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        DLog(@"获取验证码的statusCode = %ld",(long)statusCode);
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
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        block(statusCode);
        
        DLog(@"statusCode = %ld\nfailure = %@",(long)statusCode,errors);
        
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
        if (statusCode == 500) {
            [RootViewController setupLoginViewController];
        }
        
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
            DLog(@"修改个人资料 = %@",responseObject);
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
            block(@{@"statusCode": @(200), @"model": model});
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
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString * GetUrl = [NSString stringWithFormat:@"%@%@",API_config,type];
    
    [manager GET:GetUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        DLog(@"responseObject = %@",responseObject);
        block(@{@"statusCode": @(200), @"model": @"model"});
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] statusCode];
        DLog(@"获取验证码的statusCode = %ld",(long)statusCode);
        switch (statusCode) {
            case 400:
                block(@{@"statusCode": @(400), @"message": @"failure"});
                break;
            case 409:
                block(@{@"statusCode": @(409), @"message": @"failure"});
                break;
            default:
                block(@{@"statusCode": @(502), @"message": @"failure"});
                break;
        }
    }];
}


// 发布机械设备（市场）
+ (void)publishMachineWithName:(NSString *)aName type:(NSString *)aType price:(NSString *)aPrice amount:(NSString *)aAmount unit:(NSString *)aUnit description:(NSString *)aDescription WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aName) {
            [parametersDictionary setObject:aName forKey:@"name"];
        }
        if (aType) {
            [parametersDictionary setObject:aType forKey:@"type"];
        }
        if (aPrice) {
            [parametersDictionary setObject:aPrice forKey:@"price"];
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
        [manager POST:API_Publish_Machine_Market parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
}

// 发布设计（市场）
+ (void)publishDesignWithName:(NSString *)aName country:(NSString *)aCountry type:(NSString *)aType part:(NSString *)aPart price:(NSString *)aPrice amount:(NSString *)aAmount description:(NSString *)aDescription WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
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
        if (aAmount) {
            [parametersDictionary setObject:aAmount forKey:@"amount"];
        }
        
        if (aDescription) {
            [parametersDictionary setObject:aDescription forKey:@"description"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_Publish_Design_Market parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 发布辅料（市场）
+ (void)publishAccessoryWithName:(NSString *)aName price:(NSString *)aPrice amount:(NSString *)aAmount unit:(NSString *)aUnit description:(NSString *)aDescription WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aName) {
            [parametersDictionary setObject:aName forKey:@"name"];
        }
        if (aPrice) {
            [parametersDictionary setObject:aPrice forKey:@"price"];
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
        [manager POST:API_Publish_Accessory_Market parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 发布面料（市场）
+ (void)publishFabricWithName:(NSString *)aName type:(NSString *)aType price:(NSString *)aPrice width:(NSString *)aWidth amount:(NSString *)aAmount unit:(NSString *)aUnit usage:(NSString *)aUsage description:(NSString *)aDescription WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aName) {
            [parametersDictionary setObject:aName forKey:@"name"];
        }
        if (aType) {
            [parametersDictionary setObject:aType forKey:@"type"];
        }
        if (aPrice) {
            [parametersDictionary setObject:aPrice forKey:@"price"];
        }
        if (aWidth) {
            [parametersDictionary setObject:aWidth forKey:@"width"];
        }
        if (aAmount) {
            [parametersDictionary setObject:aAmount forKey:@"amount"];
        }
        if (aUnit) {
            [parametersDictionary setObject:aUnit forKey:@"unit"];
        }
        if (aUsage) {
            [parametersDictionary setObject:aUsage forKey:@"usage"];
        }
        if (aDescription) {
            [parametersDictionary setObject:aDescription forKey:@"description"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_Publish_Fabric_Market parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 搜索机械设备（市场）
+ (void)searchMachineWithType:(NSString *)aType price:(NSString *)aPrice keyword:(NSString *)aKeyword province:(NSString *)aProvince city:(NSString *)aCity page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aType) {
            [parametersDictionary setObject:aType forKey:@"type"];
        }
        if (aPrice) {
            [parametersDictionary setObject:aPrice forKey:@"price"];
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
        [manager GET:API_Search_Machine_Market parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
}

// 搜索机械设备（市场）
+ (void)searchDesignWithType:(NSString *)aType part:(NSString *)aPart price:(NSString *)aPrice keyword:(NSString *)aKeyword page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aType) {
            [parametersDictionary setObject:aType forKey:@"type"];
        }
        if (aPrice) {
            [parametersDictionary setObject:aPrice forKey:@"price"];
        }
        if (aPart) {
            [parametersDictionary setObject:aPart forKey:@"part"];
        }
        if (aKeyword) {
            [parametersDictionary setObject:aKeyword forKey:@"keyword"];
        }
        if (aPage) {
            [parametersDictionary setObject:aPage forKey:@"page"];
        }
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_Search_Design_Market parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 搜索辅料（市场）
+ (void)searchAccessoryWithPrice:(NSString *)aPrice keyword:(NSString *)aKeyword province:(NSString *)aProvince city:(NSString *)aCity page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        
        if (aPrice) {
            [parametersDictionary setObject:aPrice forKey:@"price"];
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
        [manager GET:API_Search_Accessory_Market parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 搜索面料（市场）
+ (void)searchFabricWithType:(NSString *)aType price:(NSString *)aPrice keyword:(NSString *)aKeyword province:(NSString *)aProvince city:(NSString *)aCity page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aType) {
            [parametersDictionary setObject:aType forKey:@"type"];
        }
        if (aPrice) {
            [parametersDictionary setObject:aPrice forKey:@"price"];
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
        [manager GET:API_Search_Fabric_Market parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
            
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 获取机械设备详情
+ (void)getMachineDetailWithId:(NSString *)aID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/market/machine/",aID];
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

// 获取设计详情
+ (void)getDesignDetailWithId:(NSString *)aID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/market/design/",aID];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //  DLog(@"responseObject == %@",responseObject);
            completionBlock(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
    
}

// 获取辅料详情
+ (void)getAccessoryDetailWithId:(NSString *)aID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/market/accessory/",aID];
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
// 获取面料详情
+ (void)getFabricDetailWithId:(NSString *)aID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"/market/fabric/",aID];
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
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
}

// 发布找工厂订单
+ (void)publishFactoryOrderWithSubrole:(NSString *)aSubrole type:(NSString *)aType amount:(NSString *)aAmount deadline:(NSString *)aDeadline description:(NSString *)aDescription WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    
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
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager POST:API_Piblish_Factory_Order parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
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
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
}

// 搜索供应商订单
+ (void)searchSupplierOrderWithKeyword:(NSString *)aKeyword type:(NSString *)aType WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
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
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_Search_Supplier_Order parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }
}

// 搜索找工厂订单
+ (void)searchFactoryOrderWithKeyword:(NSString *)aKeyword type:(NSString *)aType amount:(NSString *)aAmount deadline:(NSString *)aDeadline WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
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
        if (aAmount) {
            [parametersDictionary setObject:aAmount forKeyedSubscript:@"amount"];
        }
        if (aDeadline) {
            [parametersDictionary setObject:aDeadline forKeyedSubscript:@"deadline"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_Search_Factory_Order parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"responseObject == %@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DLog(@"error == %@",error);
        }];
        
    }else{
        completionBlock(@{@"statusCode": @(404), @"message": @"token不存在"});
    }

}

// 搜索设计商订单
+ (void)searchDesignOrderWithKeyword:(NSString *)aKeyword WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock{
    NSString *serviceProviderIdentifier = [[NSURL URLWithString:kBaseUrl] host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    if (credential) {
        NSMutableDictionary * parametersDictionary = [@{} mutableCopy];
        if (aKeyword) {
            [parametersDictionary setObject:aKeyword forKeyedSubscript:@"keyword"];
        }
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        [manager GET:API_Search_Design_Order parameters:parametersDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"responseObject == %@",responseObject);
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
            DLog(@"responseObject == %@",responseObject);
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

@end
