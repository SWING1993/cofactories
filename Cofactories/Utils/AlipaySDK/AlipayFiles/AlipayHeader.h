//
//  AlipayHeader.h
//  IntegratedAlipay
//
//  Created by Winann on 15/1/9.
//  Copyright (c) 2015年 Winann. All rights reserved.
//

/**
 *  1. 将本工程中的IntegratedAlipay文件夹导入工程中，记得选copy；
 *  2. 点击项目名称,点击“Build Settings”选项卡,在搜索框中,以关键字“search” 搜索,对“Header Search Paths”增加头文件路径:“$(SRCROOT)/项目名称/IntegratedAlipay/AlipayFiles”（注意：不包括引号，如果不是放到项目根目录下，请在项目名称后面加上相应的目录名）；
 *  3. 点击项目名称,点击“Build Phases”选项卡,在“Link Binary with Librarles” 选项中,新增“AlipaySDK.framework”和“SystemConfiguration.framework” 两个系统库文件。如果项目中已有这两个库文件,可不必再增加；
 *  4. 在本头文件中设置kPartnerID、kSellerAccount、kNotifyURL、kAppScheme和kPrivateKey的值（所有的值在支付宝回复的邮件里面：注意，建议除appScheme以外的字段都从服务器请求）；
 *  5. 点击项目名称,点击“Info”选项卡，在URL types里面添加一项，Identifier可以不填，URL schemes必须和appScheme的值相同，用于支付宝处理回到应用的事件；
 *  6. 在需要用的地方导入“AlipayHeader.h”，并使用“[AlipayRequestConfig alipayWithPartner:...”方法进行支付；
 *  7. 在AppDelegate中处理事件回调（可直接复制下面内容）：
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
 //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK if ([url.host isEqualToString:@"safepay"]) {
 [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
 NSLog(@"result = %@",resultDic);
 }];
 if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
 [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
 NSLog(@"result = %@",resultDic);
 }];
 }
 return YES;
 }
 */

#ifndef IntegratedAlipay_AlipayHeader_h
#define IntegratedAlipay_AlipayHeader_h


#import <AlipaySDK/AlipaySDK.h>     // 导入AlipaySDK
#import "AlipayRequestConfig.h"     // 导入支付类
#import "Order.h"                   // 导入订单类
#import "DataSigner.h"              // 生成signer的类：获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode

#import <Foundation/Foundation.h>   // 导入Foundation，防止某些类出现类似：“Cannot find interface declaration for 'NSObject', superclass of 'Base64'”的错误提示


/**
 *  partner:合作身份者ID,以 2088 开头由 16 位纯数字组成的字符串。
 *
 */
#define kPartnerID @"2088121061082553"


/**
 *  seller:支付宝收款账号,手机号码或邮箱格式。
 */
#define kSellerAccount @"admin@cofactories.com"

/**
 *  支付宝服务器主动通知商户 网站里指定的页面 http 路径。
 */
#define kNotifyURL @"https://pay.cofactories.com/alipay/test"


/**
 *  appSckeme:应用注册scheme,在Info.plist定义URLtypes，处理支付宝回调
 */
#define kAppScheme @"123"


/**
 *  private_key:商户方的私钥,pkcs8 格式。
 */
#define kPrivateKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALhEjUj0Gi/n1V8Eb+A1gEXXR2JXguE1/YJ6KEEmH5A2WP5h0XcUU9GdgIV6O4C/gzAf1jmaRhlwKweP+GawQ84vHmFF+zoEZDIiHOvHr3FJJ2SsB1zslYG3Ri0gpG023cLuMlCiy6AoxXJQn3LGfLgqeJfvLz+nhcz3vCB6EJrZAgMBAAECgYAvnNb88MYLdtX1VUorHufkI/o3+PDCjJbSrgnUu6sQMlrQcCoVoNT/prjcxHa3j8SwHKnX/Hr8e7VCoPrIXedG4Gc5u9PWukHzyYteByTuY29mJ2QmKhy1gzaCWGjkeF90kBST39oqwireWIaJZfi+sAjXAmu8crzg9s6dzB3ouQJBAPVJO557CFfSBjFbdrro+npE1p1erukhOHoIuPlTVkrQlGmZfVJKe+9IAi+36DgSzWvqDoonNblhIn0wtfYfaKcCQQDAUQSXbBRQfrrWvHHWVnNLm5G75qsTpaKlN85zpDj6UtQ+QMge+pYdaEQGWEIyOZdno2IR7ywmLc0pu5JDbNB/AkAS7j39sz0nmfwEXyzArC54tUtjBeW19Gxpbrbn9ziXuZVauQ/lA/6grwwMJsNzYHAePgg1PWV2EzsYMmQ4xJ/NAkBb2hYsUCV/sJeCGizwpweYE+xN50TMNG7zJC1JlCTWghr2xLAQA7UQxIzAzwSGwnTqveEIGchnT7bOeNTJuT33AkEA3PLB2aOV7rxnzDZisrhmxWp+KaaoM6UyY5lbMXR9SQe0yyckbJX+31b+pIGi39bnghBB5fgJFvzkqtbhDESqKg=="

#define kPublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCTSwr1a7ErecBi6tSGfXF9Q4gzOOLzb/1xJVJARtR2SGA48AVf/HGhJlNOaO1ZxX8MFlMh/p2fliJTKfmWGdncd0ceNbj5YPDxGySicSQv3P/Kbz9nvNhUqJX7sWZ4n5JW458eCu4fAIIM9qhORy7MkX1nIELiH2UubbrAxFuSoQIDAQAB"

#endif
