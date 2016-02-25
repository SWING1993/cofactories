//
//  ViewController.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/3.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (nonatomic, strong) NSDictionary *pushDic;

//主页
+ (void)setupTabarController;

//登录注册
+ (void)setupLoginViewController;

+ (void)handleNotificationInfo:(NSDictionary *)userInfo applicationState:(UIApplicationState)applicationState;

+ (void)toucHPushViewController:(UIViewController *)VC;
@end

