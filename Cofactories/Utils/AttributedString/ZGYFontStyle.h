//
//  ZGYFontStyle.h
//  Cofactories
//
//  Created by 赵广印 on 16/4/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "AttributedStyle.h"

@interface ZGYFontStyle : AttributedStyle

+ (id)withFont:(UIFont *)font range:(NSRange)range;

@end

/**
 *  内联函数
 *
 *  @param font  字体
 *  @param range 范围
 *
 *  @return 实例对象
 */
static inline AttributedStyle *fontStyle(UIFont *font, NSRange range) {
    return [ZGYFontStyle withFont:font range:range];
}