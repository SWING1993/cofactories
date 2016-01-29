//
//  AlertWithTF.h
//  Alert
//
//  Created by GTF on 16/1/25.
//  Copyright © 2016年 GUY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AlertWithTF : NSObject

/** 系统活动表
 *  @parameter 父视图控制器
 *  @parameter 标题
 *  @parameter 信息
 *  @parameter TF占位符
 *  @parameter 处理事件的标题数组
 *  @parameter 返回处理的tag值
 */

- (void)loadAlertViewInVC:(UIViewController *)viewController withTitle:(NSString *)title message:(NSString *)message textFieldPlaceHolder:(NSString *)textFieldPlaceHolder handelTitle:(NSArray *)handelTitle tfText:(void(^)(NSDictionary *dictionary))statusAndTextBlock;

@end
