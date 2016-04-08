//
//  ParagraphStyle.m
//  Cofactories
//
//  Created by 赵广印 on 16/4/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "ParagraphStyle.h"

@implementation ParagraphStyle

+ (id)withLineSpace:(CGFloat)lineSpace range:(NSRange)range {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;
    
    //也可以添加段落之间的间距，因为现在还未用到，所以只添加了行间距
    
    id paragraphStyle = [AttributedStyle attributedName:NSParagraphStyleAttributeName
                                                  value:style
                                                  range:range];
    return paragraphStyle;
}

@end
