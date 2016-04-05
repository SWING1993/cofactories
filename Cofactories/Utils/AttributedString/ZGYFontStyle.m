//
//  ZGYFontStyle.m
//  Cofactories
//
//  Created by 赵广印 on 16/4/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "ZGYFontStyle.h"

@implementation ZGYFontStyle
+ (id)withFont:(UIFont *)font range:(NSRange)range {
    
    id fontStyle = [super attributedName:NSFontAttributeName
                                  value:font
                                  range:range];
    
    return fontStyle;
}


@end
