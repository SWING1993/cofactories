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
        self.colorTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width , self.frame.size.height)];
        self.colorTitle.font = [UIFont systemFontOfSize:12*kZGY];
        self.colorTitle.textAlignment = NSTextAlignmentCenter;
        self.colorTitle.layer.cornerRadius = self.frame.size.height/2;
        self.colorTitle.clipsToBounds = YES;
        [self addSubview:self.colorTitle];
    }
    return self;
}

@end
