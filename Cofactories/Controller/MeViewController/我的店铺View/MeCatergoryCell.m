//
//  MeCatergoryCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MeCatergoryCell.h"

@implementation MeCatergoryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.catergoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.catergoryLabel.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
        self.catergoryLabel.textColor = [UIColor whiteColor];
        self.catergoryLabel.font = [UIFont systemFontOfSize:14];
        self.catergoryLabel.layer.cornerRadius = self.frame.size.height/2;
        self.catergoryLabel.clipsToBounds = YES;
        self.catergoryLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.catergoryLabel];
        
        self.deleteImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width -15, -3, 20, 20)];
        self.deleteImage.image = [UIImage imageNamed:@"删除图片"];
        [self addSubview:self.deleteImage];
        self.shanChuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shanChuButton.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height);
        self.shanChuButton.backgroundColor = [UIColor clearColor];
        [self addSubview:self.shanChuButton];
        
    }
    return self;
}

@end
