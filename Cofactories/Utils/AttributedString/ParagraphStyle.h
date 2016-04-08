//
//  ParagraphStyle.h
//  Cofactories
//
//  Created by 赵广印 on 16/4/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "AttributedStyle.h"

@interface ParagraphStyle : AttributedStyle

+ (id)withLineSpace:(CGFloat)lineSpace range:(NSRange)range;


@end
/**
 *  内联函数
 *
 *  @param lineSpace 行间距
 *  @param range 范围
 *
 *  @return 实例对象
 */
static inline AttributedStyle *paragraphStyle(CGFloat lineSpace, NSRange range) {
    return [ParagraphStyle withLineSpace:lineSpace range:range];
}