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
        self.likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 35, 0, 35, 25)];
        self.likeCountLabel.font = [UIFont systemFontOfSize:13];
        self.likeCountLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:114.0f/255.0f blue:110.0f/255.0f alpha:1.0f];
        [self addSubview:self.likeCountLabel];
        
        self.likeView = [[UIImageView alloc] initWithFrame:CGRectMake(self.likeCountLabel.frame.origin.x - 18, 5, 18, 15)];
        self.likeView.image = [UIImage imageNamed:@"popularMessage-liked"];
        [self addSubview:self.likeView];
        self.newsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.photoView.frame), self.frame.size.width, 40*kZGY)];
        self.newsTitle.numberOfLines = 2;
        self.newsTitle.font = [UIFont systemFontOfSize:12*kZGY];
        [self addSubview:self.newsTitle];
        self.commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 80*kZGY, CGRectGetMaxY(self.photoView.frame) + 17*kZGY, 80*kZGY, 20*kZGY)];
        self.commentCountLabel.textColor = [UIColor colorWithRed:83.0f/255.0f green:83.0f/255.0f blue:83.0f/255.0f alpha:1.0f];
        self.commentCountLabel.font = [UIFont systemFontOfSize:12*kZGY];
        self.commentCountLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.commentCountLabel];
    }
    return self;
}


@end
