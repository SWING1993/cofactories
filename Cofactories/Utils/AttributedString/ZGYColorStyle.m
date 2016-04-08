//
//  ZGYColorStyle.m
//  Cofactories
//
//  Created by 赵广印 on 16/4/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "ZGYColorStyle.h"

@implementation ZGYColorStyle

+ (id)withColor:(UIColor *)color range:(NSRange)range {
    id colorStyle = [AttributedStyle attributedName:NSForegroundColorAttributeName
                                              value:color
                                              range:range];
    return colorStyle;
}

@end
