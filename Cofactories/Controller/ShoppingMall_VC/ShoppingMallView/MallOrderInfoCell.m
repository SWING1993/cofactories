//
//  MallOrderInfoCell.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallOrderInfoCell.h"
#define kPhotoHeight 80
#define kMargin 15
@implementation MallOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kScreenW, kPhotoHeight + 10)];
        backgroundView.backgroundColor = GRAYCOLOR(242);
        [self addSubview:backgroundView];
        
        self.payStatus = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 0, kScreenW - 2*kMargin, 30)];
        self.payStatus.textColor = [UIColor colorWithRed:235/255.0 green:89/255.0 blue:17/255.0 alpha:1.0];
        self.payStatus.font = [UIFont systemFontOfSize:12];
        self.payStatus.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.payStatus];
        
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.payStatus.frame) + 5, kPhotoHeight, kPhotoHeight)];
        self.photoView.layer.cornerRadius = 8;
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoView.clipsToBounds = YES;
        [self addSubview:self.photoView];
        
        self.goodsTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 15, CGRectGetMaxY(self.payStatus.frame) + 5, 2*(kScreenW - 45 - kPhotoHeight)/3, 25)];
        self.goodsTitle.font = [UIFont systemFontOfSize:14];
        self.goodsTitle.textColor = GRAYCOLOR(38);
        [self addSubview:self.goodsTitle];
        
        self.goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsTitle.frame), CGRectGetMaxY(self.payStatus.frame) + 5, (kScreenW - 45 - kPhotoHeight)/3, 25)];
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
        
        self.totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(backgroundView.frame), kScreenW - 2*kMargin, 30)];
        self.totalPrice.font = [UIFont systemFontOfSize:12];
        self.totalPrice.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.totalPrice];
                
    }
    return self;
}

@end
