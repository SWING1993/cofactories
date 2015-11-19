//
//  Tools.h
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/13.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "MBProgressHUD.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject


/*!
 分割公司size

 @param sizeString size字符串

 @return firstobject 返回第一个数值  lastobject 返回第二个数值
 */
+ (NSMutableArray *)RangeSizeWith:(NSString *)sizeString;


/*!
 分割时间

 @param timeString 日期字符串

 @return 数组firstObject 返回年月日  lastOBject 返回时分秒
 */
+ (NSMutableArray *)WithTime:(NSString *)timeString;

/*!
 创建 MBProgressHUD

 @return MBProgressHUD
 */
+ (MBProgressHUD *)createHUD;


+ (NSString *)SizeWith:(NSString *)sizeString;


/*!
 几天后

 @param comps 日期

 @return 几天后
 */
+ (NSString *)compareIfTodayAfterDates:(NSDate *)comps;


/*!
 图片模糊

 @param image 需要模糊的图片

 @return 模糊过的图片
 */
+ (UIImage *)imageBlur:(UIImage *)aImage;

/*!
 计算时间
 
 @param newsDate 日期格式  @"2013-08-09 17:01"
 
 @return 距现在多长时间
 */

+ (NSString *)getUTCFormateDate:(NSString *)newsDate;


// 检查网络环境
+ (void)AFNetworkReachabilityStatusReachableVia ;


/*!
 错误信息提示框

 @param tipStr 提示框文本
 */
//+ (void)showHudTipStr:(NSString *)tipStr;


/*!
 文本闪烁信息提示框

 @param string 提示框文本
 */
+ (void)showShimmeringString:(NSString *)string;


/*!
 等待加载信息提示框

 @param string 提示框文本
 */
+ (void)showLoadString:(NSString *)string;


/*!
 正确信息提示框

 @param string 提示框文本
 */
+ (void)showSuccessWithStatus:(NSString *)string;


/*!
 错误信息提示框

 @param string 提示框文本
 */
+ (void)showErrorWithStatus: (NSString *)string;


/*!
 纯文本信息提示框

 @param string 提示框文本
 */
+ (void)showString:(NSString *)string;

+ (void)WSProgressHUDDismiss;

/*!
 传入一个String  返回文本的size

 @param string 文本
 */
+ (CGSize)getSize:(NSString *)string andFontOfSize:(CGFloat)fontSize;

@end
