//
//  HomeMarketButton.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/20.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "HomeMarketButton.h"

@implementation HomeMarketButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.marketTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*kZGY, 20*kZGY, 100*kZGY, 20*kZGY)];
        self.marketTextLabel.textColor = [UIColor colorWithRed:88.0f/255.0f green:147.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
        self.marketTextLabel.font = [UIFont boldSystemFontOfSize:14*kZGY];
//        self.marketTextLabel.font = [UIFont systemFontOfSize:14*kZGY];
        [self addSubview:self.marketTextLabel];
        self.marketDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.marketTextLabel.frame), CGRectGetMaxY(self.marketTextLabel.frame), CGRectGetWidth(self.marketTextLabel.frame), CGRectGetHeight(self.marketTextLabel.frame))];
        self.marketDetailLabel.textColor = [UIColor grayColor];
        self.marketDetailLabel.font = [UIFont systemFontOfSize:11*kZGY];
        [self addSubview:self.marketDetailLabel];
        self.marketImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 65*kZGY, 15*kZGY, 50*kZGY, 50*kZGY)];
        self.marketImage.layer.cornerRadius = 25*kZGY;
        self.marketImage.layer.masksToBounds = YES;
        self.marketImage.backgroundColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        [self addSubview:self.marketImage];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
