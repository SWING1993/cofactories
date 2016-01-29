//
//  ColorSelectCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/7.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ColorSelectCell.h"

@implementation ColorSelectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 8*kZGY;
        self.clipsToBounds = YES;
        self.colorTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width , self.frame.size.height)];
        self.colorTitle.font = [UIFont systemFontOfSize:13*kZGY];
        self.colorTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.colorTitle];
    }
    return self;
}

@end
