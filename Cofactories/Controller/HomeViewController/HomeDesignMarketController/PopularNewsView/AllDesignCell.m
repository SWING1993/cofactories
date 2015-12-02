//
//  AllDesignCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/2.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "AllDesignCell.h"

@implementation AllDesignCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.designPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        self.designPhoto.layer.cornerRadius = 25;
        self.designPhoto.clipsToBounds = YES;
        [self addSubview:self.designPhoto];
        
        self.levelPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.designPhoto.frame) - 17, CGRectGetMaxY(self.designPhoto.frame) - 17, 17, 17)];
        self.levelPhoto.layer.cornerRadius = 8.5;
        self.levelPhoto.clipsToBounds = YES;
        [self addSubview:self.levelPhoto];
        
        self.designTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.designPhoto.frame) + 15, 15, kScreenW - 15 - 35 - 20 - 90, 25)];
//        self.designTitle.backgroundColor = [UIColor grayColor];
        self.designTitle.font = [UIFont systemFontOfSize:15];
        self.designTitle.textColor = [UIColor colorWithRed:38.0f/255.0f green:38.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
        [self addSubview:self.designTitle];
        
        self.classTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.designTitle.frame.origin.x, CGRectGetMaxY(self.designTitle.frame), 80, 25)];
        self.classTitle.font = [UIFont systemFontOfSize:13];
        self.classTitle.textColor = [UIColor colorWithRed:158.0f/255.0f green:158.0f/255.0f blue:158.0f/255.0f alpha:1.0f];
        [self addSubview:self.classTitle];
        
        self.addressTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.classTitle.frame), self.classTitle.frame.origin.y, kScreenW - 80 - 80 - 15 - 35 - 20 - 10, 25)];
//        self.addressTitle.backgroundColor = [UIColor grayColor];
        self.addressTitle.font = [UIFont systemFontOfSize:13];
        self.addressTitle.textColor = [UIColor colorWithRed:158.0f/255.0f green:158.0f/255.0f blue:158.0f/255.0f alpha:1.0f];
        [self addSubview:self.addressTitle];

        self.likeCount = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 15 - 35, 15, 35, 25)];
        self.likeCount.textColor = [UIColor colorWithRed:255.0f/255.0f green:69.0f/255.0f blue:65.0f/255.0f alpha:1.0f];
        self.likeCount.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.likeCount];
        
        self.likePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - self.likeCount.frame.size.width - 15 - 15 - 5, 20, 15, 15)];
        [self addSubview:self.likePhoto];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80 - 0.3, kScreenW, 0.3)];
        lineView.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:207.0f/255.0f alpha:1.0f];
        [self addSubview:lineView];
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
