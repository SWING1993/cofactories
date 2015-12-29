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
 *  appSckeme:应用注册scheme,在Info.plist定义URLtypes，处理支付宝回调
 */
#define kAppScheme @"cofactories10446627"


/**
 *  private_key:商户方的私钥,pkcs8 格式。
 */
#define kPrivateKey @"MIIEwAIBADANBgkqhkiG9w0BAQEFAASCBKowggSmAgEAAoIBAQCzC6cUNkss/rcMrwBR+9cDyt0IedkHxMlxDFFg8MhYGR3YukazBfbaotwqyEeauzoyUE2v5ki8+Nz0JT7NfaTXD1flsyyiJUIRogHh4qhurJhlBcZ9OpSmXqirVHDrtagkgqzIGLgUPFKqxNjrwNaiaf49bk8O8+P7vF5gL2BlLd6qeMYOZp7vmbpzK9HCMjJXrfxXlwRf/UYj6+KUjB00mGppMNt22qiK5qB7iTHgvIDoTrIfwKVcNwdzJdrNikCeYHE6zfsCJzxHJ3D+2EXljgOp3FeNf4lYzwur9Ir3JsuxqdbU5JlcejoWj5K9Vs56EKIu+vHc+W10iMYjnJxZAgMBAAECggEBAIfXkHVCWDkULFegMvMAyvqioJ68q9A8GsX9nYSaSrakn8N+WQOcw9TP+ZEwETuxT4865CZP5uIRQrqtw39vE3DjwEGTdoqzD/SG4Ty7liUaKCmFfzomBwBPE1OiJmZ/lcnVpzfNoWQg/Gt6HEaKMY5aMr3zAmKK4m9tVIFPkKhSJsWWgEnwJo0+2xygbROYriiF2KWQogYYtVMXlmlZ6oHeM9Bz3QqFvKfpf0lX5WIC8HCqxR9Lnrod1hsxGPuHvJBaQ33KVM2lRrmwKop5LAmAfAxkwRNfds7r2IcpVnD7jfnVe+Wvm8mwzxSzT2v5dqwBoFmak521B02p21L62wECgYEA4Dy7J7TYF5+inERLPn7vy+zvwyepEXsgPNStp7akcrGNSaVP4KIDnCSPR2Hr9xLSBRmsS/jm6EerLn5Sw7Oye/jw55SJ9edSgTiBzQ3cH9JLHjA8dWLreUPuLMQbX/eGs2y+1JmM93uyOJRgfrYwqp9IglEDlnO8ZuqS1QKkjeECgYEAzGgvHPxcb6HcWqJ0I3pW6w6sCGR+lU44EgRH8qDSOSMrTtIJ9vPcbC32zpxa1fSgQ+1YH1QOT18qg3W3f5eWL49cFl5eFCYfDDasFc2DW0rDzWFxZSDuskyaRuqEFJM31RBET6zNh/QlnhUxW8Ai0ODsIaRhYSUkBOSZgWGFLXkCgYEAkIMTKpfF3BOpPIRW6cPszsO4EVFyCC4NrKZz8+4lNTVwFNJRFDfVk7+MBzj4VZbvexH8lEmopnHpxGDs/erFUFgzCUwVTUDzTwwXuwr/nhJtDtuPWyeREenRiVApREPFr8SZh3IeAzDYvtYBCihoXM2icTm80i1scfcjAdxeKIECgYEAumUe4T23RQzClduiMF/1Nq/QbG7Hh3smYjeJLFU+nl/VtDCQaaOCkxtu/oVRx90k8AxU2WybCAHuEKadyDoA+Cmwfa1b+N+yXD7WuaMIb41D89sxvlhDkk+MN7LO8rw0o5QL1uPrIFignQESW2pf1T3l1d/B9QYbTGLxICw/d3ECgYEA2cqk+aYJcZXvgBQ52DufzgpkP3csRTQU6ThYPwuKc4lxSMMG9lBsC7jM2af1jLcA8HltUCT3OwsLmTgSW1yIUVJVZTXzQD3TQCGct7upvnyKVXR59W0xM+YODIkJCxLoN3XrxXXi0cXI83TOXNZ+/SyxSTwgbKc2hAmCe/WLLuI="

#endif
