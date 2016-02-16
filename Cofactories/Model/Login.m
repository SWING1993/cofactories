//
//  Login.m
//  Cofactories
//
//  Created by 宋国华 on 16/1/12.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "Login.h"

static UserModel *curLoginUser;

@implementation Login

#define kLoginPreUserPhone @"pre_user_phone"
#define kLoginUserDict @"user_dict"
#define kLoginDataListPath @"login_data_list_path.plist"

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.remember_me = [NSNumber numberWithBool:YES];
        self.phone = @"";
        self.password = @"";
    }
    return self;
}

- (NSString *)toPath{
    NSString *path;
    path = @"api/account/login/phone";
    return path;
}
- (NSDictionary *)toParams{
    NSMutableDictionary *params = @{@"phone" : self.phone, @"password" : [self.password sha1Str],
                                    @"remember_me" : self.remember_me? @"true" : @"false",}.mutableCopy;
    return params;
}


+ (BOOL)isLogin{    
    if ([HttpClient getToken]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void) doLogout {
    [HttpClient deleteToken];
}
+ (BOOL)saveLoginData{
    BOOL saved = NO;
    NSMutableDictionary *loginDataList = [self readLoginDataList];
    UserModel * model = [UserModel User];
    if (model.phone.length > 0) {
        [loginDataList setValue:model.uid forKey:model.phone];
//        [loginDataList setObject:data forKey:model.phone];
        saved = YES;
    }
    if (saved) {
        saved = [loginDataList writeToFile:[self loginDataListPath] atomically:YES];
        DLog(@"loginDataList = %@",[self loginDataListPath]);
    }
    
    return saved;
}


+ (NSMutableDictionary *)readLoginDataList{
    NSMutableDictionary *loginDataList = [NSMutableDictionary dictionaryWithContentsOfFile:[self loginDataListPath]];
    if (!loginDataList) {
        loginDataList = [NSMutableDictionary dictionary];
    }
    return loginDataList;
}

+ (NSString *)loginDataListPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:kLoginDataListPath];
}




+ (void)setPreUserPhone:(NSString *)phoneStr{
    if (phoneStr.length <= 0) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:phoneStr forKey:kLoginPreUserPhone];
    [defaults synchronize];
}

+ (NSString *)preUserPhone{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kLoginPreUserPhone];
}

@end
