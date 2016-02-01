//
//  MallHistoryOrderCell.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/30.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallHistoryOrderCell.h"
#define kPhotoHeight 80
#define kMargin 15
#define kHeight 35

@implementation MallHistoryOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight, kScreenW, kPhotoHeight + 10)];
        backgroundView.backgroundColor = GRAYCOLOR(242);
        [self addSubview:backgroundView];
        
        self.goodsStatus = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 0, kScreenW - 2*kMargin, kHeight)];
        self.goodsStatus.textColor = [UIColor colorWithRed:235/255.0 green:89/255.0 blue:17/255.0 alpha:1.0];
        self.goodsStatus.font = [UIFont systemFontOfSize:13];
        self.goodsStatus.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.goodsStatus];
        
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.goodsStatus.frame) + 5, kPhotoHeight, kPhotoHeight)];
        self.photoView.layer.cornerRadius = 8;
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoView.clipsToBounds = YES;
        [self addSubview:self.photoView];
        
        self.goodsTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 15, CGRectGetMaxY(self.goodsStatus.frame) + 5, 2*(kScreenW - 45 - kPhotoHeight)/3, 25)];
        self.goodsTitle.font = [UIFont systemFontOfSize:14];
        self.goodsTitle.textColor = GRAYCOLOR(38);
        [self addSubview:self.goodsTitle];
        
        self.goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsTitle.frame), CGRectGetMaxY(self.goodsStatus.frame) + 5, (kScreenW - 45 - kPhotoHeight)/3, 25)];
        self.goodsPrice.textAlignment = NSTextAlignmentRight;
        self.goodsPrice.textColor = GRAYCOLOR(38);
        self.goodsPrice.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.goodsPrice];
        
        self.goodsCategory = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.goodsTitle.frame), CGRectGetMaxY(self.goodsTitle.frame), CGRectGetWidth(self.goodsTitle.frame), 25)];
        self.goodsCategory.font = [UIFont systemFontOfSize:14];
        self.goodsCategory.textColor = GRAYCOLOR(143);
        [self addSubview:self.goodsCategory];
        
        self.goodsNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsCategory.frame), CGRectGetMaxY(self.goodsPrice.frame), CGRectGetWidth(self.goodsPrice.frame), 25)];
        self.goodsNumber.font = [UIFont systemFontOfSize:14];
        self.goodsNumber.textColor = GRAYCOLOR(143);
        self.goodsNumber.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.goodsNumber];
        
        self.totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(backgroundView.frame), kScreenW - 2*kMargin, kHeight)];
        self.totalPrice.font = [UIFont systemFontOfSize:13];
        self.totalPrice.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.totalPrice];
        
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(0, CGRectGetMaxY(self.totalPrice.frame), kScreenW, 0.3);
        line.backgroundColor = kLineGrayCorlor.CGColor;
        [self.layer addSublayer:line];
        
        self.changeStatus = [UIButton buttonWithType:UIButtonTypeCustom];
        self.changeStatus.frame = CGRectMake(kScreenW - 70 - kMargin, CGRectGetMaxY(self.totalPrice.frame) + 5, 70, kHeight - 10);
        self.changeStatus.layer.borderWidth = 1;
        self.changeStatus.layer.borderColor = kDeepBlue.CGColor;
        self.changeStatus.layer.cornerRadius = 5;
        self.changeStatus.clipsToBounds = YES;
        self.changeStatus.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.changeStatus setTitleColor:kDeepBlue forState:UIControlStateNormal];
        [self addSubview:self.changeStatus];
        
    }
    return self;
}





@end
