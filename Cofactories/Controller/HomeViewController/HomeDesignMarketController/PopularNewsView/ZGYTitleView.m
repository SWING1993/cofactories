//
//  ZGYTitleView.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/28.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ZGYTitleView.h"
#define kLeftLabelHeight 15
#define kTitleLabelHeight 25


@implementation ZGYTitleView


- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title leftLabelColor:(UIColor *)leftLabelColor
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame)/2 - kLeftLabelHeight/2, 3, kLeftLabelHeight)];
        leftLabel.layer.cornerRadius = 1.5;
        leftLabel.clipsToBounds = YES;
        if ([leftLabelColor isEqual:NULL]) {
            leftLabel.backgroundColor = [UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
        } else {
            leftLabel.backgroundColor = leftLabelColor;
        }
        [self addSubview:leftLabel];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(leftLabel.frame) + 10, CGRectGetHeight(self.frame)/2 - kTitleLabelHeight/2, kScreenW - 30, kTitleLabelHeight)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = title;
        [self addSubview:titleLabel];
        
    }
    return self;
}



@end
