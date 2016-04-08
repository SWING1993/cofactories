//
//  NSString+AttributedStyle.m
//  Cofactories
//
//  Created by 赵广印 on 16/4/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "NSString+AttributedStyle.h"

@implementation NSString (AttributedStyle)


- (NSAttributedString *)creatAttributedStringWithStyles:(NSArray *)styles {
    if (self.length <= 0) {
        return nil;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (int count = 0; count < styles.count; count++) {
        AttributedStyle *style = styles[count];
        
        [attributedString addAttribute:style.attributedName
                                 value:style.value
                                 range:style.range];
    }
    
    return attributedString;
}
@end
