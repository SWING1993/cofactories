//
//  NSString+AttributedStyle.h
//  Cofactories
//
//  Created by 赵广印 on 16/4/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributedStyle.h"

@interface NSString (AttributedStyle)
/**
 *  根据styles数组创建出富文本
 *
 *  @param styles AttributedStyle对象构成的数组
 *
 *  @return 富文本
 */

- (NSAttributedString *)creatAttributedStringWithStyles:(NSArray *)styles;

@end
