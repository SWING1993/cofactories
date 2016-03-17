//
//  UIButton+CountDown.h
//  Cofactories
//
//  Created by 宋国华 on 16/1/11.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CountDown)

/*
 *    倒计时按钮
 *    @param timeLine  倒计时总时间
 *    @param title     还没倒计时的title
 *    @param subTitle  倒计时的子名字 如：时、分

 */
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle;

/**
 *  更改点击不可点击时候的BackGroundColor和Title
 *
 *  @param userInteractionEnabled userInteractionEnabled
 */
- (void)changeState:(BOOL)userInteractionEnabled;


/**
 *  添加Shake动画
 */
- (void)addShakeAnimation;

@end
