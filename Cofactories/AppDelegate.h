//
//  AppDelegate.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/3.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>
// 引用 IMKit 头文件。
#import <RongIMKit/RongIMKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCIMConnectionStatusDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

