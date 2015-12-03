//
//  ProcessMarketListCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/3.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ProcessMarketListCell.h"

#define kProcessMargin 40*kZGY

@implementation ProcessMarketListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(kProcessMargin, kProcessMargin, (kScreenW - kProcessMargin*6)/3, (kScreenW - kProcessMargin*6)/3)];
//        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.photoView];
        self.processTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.photoView.frame) + 5*kZGY, kScreenW/3, 20*kZGY)];
        self.processTitle.font = [UIFont systemFontOfSize:14*kZGY];
        self.processTitle.textAlignment = NSTextAlignmentCenter;
        self.processTitle.textColor = [UIColor colorWithRed:25.0f/255.0f green:25.0f/255.0f blue:25.0f/255.0f alpha:1.0f];
        [self addSubview:self.processTitle];
    }
    return self;
}

@end
