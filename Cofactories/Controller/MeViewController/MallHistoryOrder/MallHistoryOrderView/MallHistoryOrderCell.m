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
        self.changeStatus.layer.borderColor = kMainDeepBlue.CGColor;
        self.changeStatus.layer.cornerRadius = 5;
        self.changeStatus.clipsToBounds = YES;
        self.changeStatus.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.changeStatus setTitleColor:kMainDeepBlue forState:UIControlStateNormal];
        [self addSubview:self.changeStatus];
        
    }
    return self;
}


- (void)reloadMallBuyHistoryOrderDataWithMallBuyHistoryModel:(MallBuyHistoryModel *)mallBuyHistoryModel {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.goodsStatus.text = mallBuyHistoryModel.waitPayType;
    if (mallBuyHistoryModel.photoArray.count > 0) {
        NSString* encodedString = [[NSString stringWithFormat:@"%@%@", PhotoAPI, mallBuyHistoryModel.photoArray[0]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"MallNoPhoto"]];
    } else {
        self.photoView.image = [UIImage imageNamed:@"MallNoPhoto"];
    }
    self.goodsTitle.text = mallBuyHistoryModel.name;
    self.goodsPrice.text = [NSString stringWithFormat:@"¥ %@", mallBuyHistoryModel.price];
    self.goodsCategory.text = mallBuyHistoryModel.category;
    self.goodsNumber.text = [NSString stringWithFormat:@"x%@", mallBuyHistoryModel.amount];
    self.totalPrice.text = [NSString stringWithFormat:@"共%@件商品 合计：¥ %@", mallBuyHistoryModel.amount, mallBuyHistoryModel.totalPrice];
    
    if (mallBuyHistoryModel.status == 4) {
        if ([mallBuyHistoryModel.comment isEqualToString:@"2"]) {
            [self.changeStatus setTitle:@"待卖家评" forState:UIControlStateNormal];
        } else {
            [self.changeStatus setTitle:@"评价" forState:UIControlStateNormal];
        }
    } else {
        [self.changeStatus setTitle:mallBuyHistoryModel.payType forState:UIControlStateNormal];
    }
    self.showButton = mallBuyHistoryModel.showButton;//判断button是否隐藏
//    [self.changeStatus addTarget:self action:@selector(actionOfStatus:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)reloadMallSellHistoryOrderDataWithMallSellHistoryModel:(MallSellHistoryModel *)mallSellHistoryModel {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.goodsStatus.text = mallSellHistoryModel.waitPayType;
    if (mallSellHistoryModel.photoArray.count > 0) {
        NSString* encodedString = [[NSString stringWithFormat:@"%@%@", PhotoAPI, mallSellHistoryModel.photoArray[0]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"MallNoPhoto"]];
    } else {
        self.photoView.image = [UIImage imageNamed:@"MallNoPhoto"];
    }
    self.goodsTitle.text = mallSellHistoryModel.name;
    self.goodsPrice.text = [NSString stringWithFormat:@"¥ %@", mallSellHistoryModel.price];
    self.goodsCategory.text = mallSellHistoryModel.category;
    self.goodsNumber.text = [NSString stringWithFormat:@"x%@", mallSellHistoryModel.amount];
    self.totalPrice.text = [NSString stringWithFormat:@"共%@件商品 合计：¥ %@", mallSellHistoryModel.amount, mallSellHistoryModel.totalPrice];
    
    switch (mallSellHistoryModel.status) {
        case 2:
            [self.changeStatus setTitle:@"确认发货" forState:UIControlStateNormal];
            break;
        case 4:
            if ([mallSellHistoryModel.comment isEqualToString:@"1"]){
                [self.changeStatus setTitle:@"待买家评" forState:UIControlStateNormal];
            } else {
                [self.changeStatus setTitle:@"评价" forState:UIControlStateNormal];
            }
            break;
        case 5:
            [self.changeStatus setTitle:@"已完成" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    self.showButton = mallSellHistoryModel.showButton;//判断button是否隐藏
}

//购买历史记录某个订单详情
- (void)reloadMallBuyHistoryOrderDetailDataWithMallBuyHistoryModel:(MallBuyHistoryModel *)mallBuyHistoryModel {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.goodsStatus.text = mallBuyHistoryModel.waitPayType;
    if (mallBuyHistoryModel.photoArray.count > 0) {
        NSString* encodedString = [[NSString stringWithFormat:@"%@%@", PhotoAPI, mallBuyHistoryModel.photoArray[0]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"MallNoPhoto"]];
    } else {
        self.photoView.image = [UIImage imageNamed:@"MallNoPhoto"];
    }
    self.goodsTitle.text = mallBuyHistoryModel.name;
    self.goodsPrice.text = [NSString stringWithFormat:@"¥ %@", mallBuyHistoryModel.price];
    self.goodsCategory.text = mallBuyHistoryModel.category;
    self.goodsNumber.text = [NSString stringWithFormat:@"x%@", mallBuyHistoryModel.amount];
    self.totalPrice.text = [NSString stringWithFormat:@"共%@件商品 合计：¥ %@", mallBuyHistoryModel.amount, mallBuyHistoryModel.totalPrice];
    [self.changeStatus setTitle:@"联系卖家" forState:UIControlStateNormal];
}
//出售历史记录某个订单详情
- (void)reloadMallSellHistoryOrderDetailDataWithMallSellHistoryModel:(MallSellHistoryModel *)mallSellHistoryModel {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.goodsStatus.text = mallSellHistoryModel.waitPayType;
    if (mallSellHistoryModel.photoArray.count > 0) {
        NSString* encodedString = [[NSString stringWithFormat:@"%@%@", PhotoAPI, mallSellHistoryModel.photoArray[0]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"MallNoPhoto"]];
    } else {
        self.photoView.image = [UIImage imageNamed:@"MallNoPhoto"];
    }
    self.goodsTitle.text = mallSellHistoryModel.name;
    self.goodsPrice.text = [NSString stringWithFormat:@"¥ %@", mallSellHistoryModel.price];
    self.goodsCategory.text = mallSellHistoryModel.category;
    self.goodsNumber.text = [NSString stringWithFormat:@"x%@", mallSellHistoryModel.amount];
    self.totalPrice.text = [NSString stringWithFormat:@"共%@件商品 合计：¥ %@", mallSellHistoryModel.amount, mallSellHistoryModel.totalPrice];
    self.changeStatus.hidden = YES;
}

@synthesize showButton = _showButton;
- (void)setShowButton:(BOOL)showButton
{
    _showButton = showButton;
    if (_showButton == YES)
    {
        _changeStatus.alpha = 1;
    }
    else
    {
        _changeStatus.alpha = 0;
    }
}



@end
