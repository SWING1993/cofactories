//
//  AttributedStyle.m
//  Cofactories
//
//  Created by 赵广印 on 16/4/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "AttributedStyle.h"

@implementation AttributedStyle

+ (AttributedStyle *)attributedName:(NSString *)attributedName value:(id)value range:(NSRange)range {
    AttributedStyle *style = [[self class] new];
    
    style.attributedName = attributedName;
    style.value = value;
    style.range = range;
    
    return style;
}


@end
