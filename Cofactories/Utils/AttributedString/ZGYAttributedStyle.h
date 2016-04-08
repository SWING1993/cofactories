//
//  ZGYAttributedStyle.h
//  Cofactories
//
//  Created by 赵广印 on 16/4/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#ifndef ZGYAttributedStyle_h
#define ZGYAttributedStyle_h

#import "NSString+AttributedStyle.h"
#import "ZGYFontStyle.h"
#import "ZGYColorStyle.h"
#import "ParagraphStyle.h"

/**
 *  富文本的使用
 *
 *  @param fontStyle() 修改字体大小
 *
 *  @param colorStyle() 修改字体颜色
 *
 *  @param paragraphStyle 修改字体的行间距
 *
 */

/* ------------------富文本的使用---------------------------------
    
label.attributedText = [string creatAttributedStringWithStyles:@[fontStyle(<#UIFont *font#>, <#NSRange range#>), colorStyle(<#UIColor *color#>, <#NSRange range#>), paragraphStyle(<#CGFloat lineSpace#>, <#NSRange range#>)]];

*/

#endif /* ZGYAttributedStyle_h */
