//
//  AppDelegate.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/3.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"


#import "UMessage.h"
#import "MobClick.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsService.h"
#import "UMSocialQQHandler.h"
//腾讯Bugly
#import <Bugly/CrashReporter.h>

//支付宝
#import <AlipaySDK/AlipaySDK.h>

//腾讯bugly
#define Appkey_bugly @"900009962"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:kScreenBounds];
    self.window.backgroundColor = [UIColor whiteColor];
#pragma mark - 腾讯buglySDK
    {
        //关闭友盟bug检测
        [MobClick setCrashReportEnabled:NO];
        //开启腾讯Bugly
        [[CrashReporter sharedInstance] installWithAppId:Appkey_bugly];
    }

    
#pragma mark - 融云SDK
    {
        //初始化融云SDK。
        [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
        [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
        
        /**
         * 融云推送处理1
         */
        if ([application
             respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                    settingsForTypes:(UIUserNotificationTypeBadge |
                                                                      UIUserNotificationTypeSound |
                                                                      UIUserNotificationTypeAlert)
                                                    categories:nil];
            [application registerUserNotificationSettings:settings];
        } else {
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
            UIRemoteNotificationTypeAlert |
            UIRemoteNotificationTypeSound;
            [application registerForRemoteNotificationTypes:myTypes];
        }
    }
    
#pragma mark - 友盟SDK
    {
        // 注册友盟推送服务 SDK
        //set AppKey and LaunchOptions
        [UMessage startWithAppkey:Appkey_Umeng launchOptions:launchOptions];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
        if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            //register remoteNotification types
            UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
            action1.identifier = @"action1_identifier";
            action1.title=@"Accept";
            action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
            
            UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
            action2.identifier = @"action2_identifier";
            action2.title=@"Reject";
            action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
            action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
            action2.destructive = YES;
            
            UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
            categorys.identifier = @"category1";//这组动作的唯一标示
            [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
            
            UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                         categories:[NSSet setWithObject:categorys]];
            [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
            DLog(@"iOS8");
        } else{
            //register remoteNotification types
            [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
             |UIRemoteNotificationTypeSound
             |UIRemoteNotificationTypeAlert];
            DLog(@"iOS7");
            
        }
        
#else
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
#endif
        //for log
        [UMessage setLogEnabled:YES];
        
        [UMSocialData setAppKey:Appkey_Umeng];
        //设置微信AppId、appSecret，分享url
        [UMSocialWechatHandler setWXAppId:@"wxdf66977ff3f413e2" appSecret:@"a6e3fe6788a9a523cb6657e0ef7ae9f4" url:@"http://www.umeng.com/social"];
        //设置分享到QQ/Qzone的应用Id，和分享url 链接
        [UMSocialQQHandler setQQWithAppId:@"1104779454" appKey:@"VNaZ1cQfyRS2C3I7" url:@"http://www.umeng.com/social"];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
        
        //友盟统计 SDK
        [MobClick startWithAppkey:Appkey_Umeng reportPolicy:SENDDAILY channelId:@"appStore"];// 启动时发送 Log AppStore分发渠道
        [MobClick setAppVersion:kVersion_Cofactories];
    }
   

    RootViewController *mainVC = [[RootViewController alloc] init];
    self.window.rootViewController = mainVC;
    [self customizeInterface];
    [_window makeKeyAndVisible];
    
    //修改app默认UA
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    DLog(@"------%@",userAgent);
    
    NSString *ua = [NSString stringWithFormat:@"%@ CoFactories-iOS-%@",
                    userAgent,
                    kVersion_Cofactories];
    DLog(@"------%@",ua);
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
    
    return YES;
}
/**
 * 融云推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
 
    
    DLog(@"deviceToken = %@",[NSString stringWithFormat:@"%@", deviceToken]);
    [HttpClient iOSLaunchWithDeviceId:[NSString stringWithFormat:@"%@", deviceToken] WithClientVersion:kVersion_Cofactories];
    
    [UMessage registerDeviceToken:deviceToken];
    /**
     * 融云推送处理3
     */
    NSString *token =[[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                                            withString:@""]
                       stringByReplacingOccurrencesOfString:@">"
                       withString:@""]
                      stringByReplacingOccurrencesOfString:@" "
                      withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"推送error = %@",error);
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
   
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
                NSLog(@"result1 = %@",resultDic);
                NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"]integerValue];
                [self showAlertWithResultStatus:resultStatus];

            }];
        }
        if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
            
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
                NSLog(@"result2 = %@",resultDic);
                NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"]integerValue];
                [self showAlertWithResultStatus:resultStatus];
            }];
        }

    }
    return result;
}

- (void)showAlertWithResultStatus:(NSInteger )resultStatus {
    switch (resultStatus) {
        case 4000:
            kTipAlert(@"订单支付失败");
            break;
        case 6001:
            kTipAlert(@"用户中途取消");
            break;
        case 6002:
            kTipAlert(@"网络连接出错");
            break;
        case 8000:
            kTipAlert(@"支付结果确认中");
            break;
        case 9000:
            kTipAlert(@"订单支付成功");
            break;
            
        default:
            kTipAlert(@"充值错误（%ld）",(long)resultStatus);
            break;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    //app图标未读信息条数
    application.applicationIconBadgeNumber = unreadMsgCount;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - RCIMConnectionStatusDelegate

/**
 *  IM登陆状态
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
       
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

/**
 *  tabBarItem 的选中和不选中文字属性、背景图片
 */
- (void)customizeInterface {
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];

    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                                     NSForegroundColorAttributeName: [UIColor blackColor],
                                     };
    [navigationBarAppearance setTitleTextAttributes:textAttributes];

    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
}




@end
