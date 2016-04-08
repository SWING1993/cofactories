//
//  ZGYColorStyle.h
//  Cofactories
//
//  Created by 赵广印 on 16/4/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "AttributedStyle.h"

@interface ZGYColorStyle : AttributedStyle

+ (id)withColor:(UIColor *)color range:(NSRange)range;

@end

/**
 *  内联函数
 *
 *  @param color 字体颜色
 *  @param range 范围
 *
 *  @return 实例对象
 */
static inline AttributedStyle *colorStyle(UIColor *color, NSRange range) {
    return [ZGYColorStyle withColor:color range:range];
}