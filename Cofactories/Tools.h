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

+ (MBProgressHUD *)createHUDWithView:(UIView *)bigView;

/**
 *  提示View
 *
 *  @param tipStr 提示String
 */
+ (void)showHudTipStr:(NSString *)tipStr;

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
+ (void)AFNetworkReachabilityStatusReachableVia;


/*!
 传入一个String  返回文本的size

 @param string 文本
 */
+ (CGSize)getSize:(NSString *)string andFontOfSize:(CGFloat)fontSize;

+ (CGSize)getSize:(NSString *)string andFontOfSize:(CGFloat)fontSize andWidthMake:(CGFloat)width;//自适应高度

/**
 *  清除缓存
 */
+ (void)removeAllCached;

/**
 *  图片旋转
 */
+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView;


// 商家汇总筛选条件
+ (NSDictionary *)returenSelectDataDictionaryWithIndex:(NSInteger)index;

// 商品购买筛选条件
+ (NSDictionary *)goodsSelectDataDictionaryWithIndex:(NSInteger)index;


/**
 *  判断字符串为空和只为空格解决办法
 *
 *  @param string String
 *
 *  @return BOOL
 */
+ (BOOL)isBlankString:(NSString *)string;


/**
 *  ScrollView长截图
 *
 *  @param scrollView 视图
 *
 *  @return 图片
 */
+ (UIImage *)captureScrollView:(UIScrollView *)scrollView ;



+ (void)saveImageToMyAlbumWithOrderID:(NSString *)orderID;

//点击放大效果
+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer isToBig:(BOOL)isToBig;

//蓝色圆角button
+ (UIButton *)buttonWithFrame:(CGRect)frame withTitle:(NSString *)title;

// UPYun上传
+ (void)upLoadImagesWithArray:(NSMutableArray *)array
                 policyString:(NSString *)policyString
              signatureString:(NSString *)signatureString;

@end
