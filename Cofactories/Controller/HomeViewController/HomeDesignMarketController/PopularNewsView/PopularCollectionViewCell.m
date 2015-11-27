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
        
        self.newsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.photoView.frame), self.frame.size.width, 40)];
        self.newsTitle.numberOfLines = 2;
        self.newsTitle.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.newsTitle];
    }
    return self;
}


@end
