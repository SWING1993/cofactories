//
//  HomeMarketCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/21.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "HomeMarketCell.h"
#import "HomeMarketButton.h"
@implementation HomeMarketCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSArray *titleArray = @[@"设计市场", @"服装市场", @"供应市场", @"加工配套"];
    NSArray *detailArray = @[@"版型设计师一体收纳", @"服装企业大汇总", @"面辅机械一网打尽", @"一站式加工服务"];
    NSArray *photoArray = @[@"Home_market_design", @"Home_market_cloth", @"Home_market_supply", @"Home_market_processed"];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (NSInteger i = 0; i < 4; i++) {
            HomeMarketButton *marketButton = [[HomeMarketButton alloc] initWithFrame:CGRectMake((i%2)*(kScreenW/2), (i/2)*80*kZGY, kScreenW/2, 80*kZGY)];
            [marketButton addTarget:self action:@selector(marketButtonAction:)  forControlEvents:UIControlEventTouchUpInside];
            marketButton.tag = i + 1;
            marketButton.marketTextLabel.text = titleArray[i];
            marketButton.marketDetailLabel.text = detailArray[i];
            marketButton.marketImage.image = [UIImage imageNamed:photoArray[i]];
            [self addSubview:marketButton];
        }
        UILabel *horizontalLabel = [[UILabel alloc] initWithFrame:CGRectMake(5*kZGY, 80*kZGY, kScreenW - 10*kZGY, 0.3)];
        horizontalLabel.backgroundColor = kLineGrayCorlor;
        [self addSubview:horizontalLabel];
        UILabel *verticalLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2, 5*kZGY, 0.3, 150*kZGY)];
        verticalLabel.backgroundColor = kLineGrayCorlor;
        [self addSubview:verticalLabel];
    }
    return self;
}

- (void)marketButtonAction:(HomeMarketButton *)marketButton {
    [_delegate homeMarketCell:self marketButtonTag:marketButton.tag];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
