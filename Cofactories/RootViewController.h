//
//  ViewController.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/3.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroPage.h"
#import "EAIntroView.h"
@interface RootViewController : UIViewController <EAIntroDelegate,UIApplicationDelegate>

//主页
+(void)setupTabarController;

//登录注册
+ (void)setupLoginViewController;

@end

