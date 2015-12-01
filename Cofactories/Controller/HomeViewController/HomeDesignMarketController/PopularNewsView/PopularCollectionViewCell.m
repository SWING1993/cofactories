//
//  PopularCollectionViewCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "PopularCollectionViewCell.h"

@implementation PopularCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        [self addSubview:self.photoView];
        
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.likeButton.frame = CGRectMake(self.frame.size.width - 43, 3, 40, 40);
        [self addSubview:self.likeButton];
        self.newsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.photoView.frame), self.frame.size.width, 40*kZGY)];
        self.newsTitle.numberOfLines = 2;
        self.newsTitle.font = [UIFont systemFontOfSize:12*kZGY];
        [self addSubview:self.newsTitle];
    }
    return self;
}


@end
