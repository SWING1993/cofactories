//
//  ActivityListCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/29.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "ActivityListCell.h"

@implementation ActivityListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.activityTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 20)];
        self.activityTitle.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:self.activityTitle];
        self.activityDetail = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.activityTitle.frame), self.frame.size.width - 20, 20)];
        self.activityDetail.font = [UIFont systemFontOfSize:12];
        self.activityDetail.textColor = [UIColor lightGrayColor];
        [self addSubview:self.activityDetail];
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.activityDetail.frame) + 5, self.frame.size.width - 20, (self.frame.size.width - 20)*256/640)];
        
        [self addSubview:self.photoView];
    }
    return self;
}

@end
