//
//  ZGYSupplyMarketView.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/30.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ZGYSupplyMarketView.h"
#import "ZGYTitleView.h"
#import "SupplyMarketButton.h"
#define kButtonHeight 100

@implementation ZGYSupplyMarketView

- (instancetype)initWithFrame:(CGRect)frame photoArray:(NSArray *)photoArray titleArray:(NSArray *)titleArray detailTitleArray:(NSArray *)detailTitleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        ZGYTitleView *titleView = [[ZGYTitleView alloc] initWithFrame:CGRectMake(0, 7, kScreenW, 30) Title:@"全部分类" leftLabelColor:[UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f]];
        [self addSubview:titleView];
        for (int i = 0; i < 3; i++) {
            SupplyMarketButton *btn = [[SupplyMarketButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleView.frame) + 5 + i*(10 + kButtonHeight), kScreenW - 20, kButtonHeight)];
            btn.photoView.image = [UIImage imageNamed:photoArray[i]];
            btn.supplyTitle.text = titleArray[i];
            btn.supplyDetail.text = detailTitleArray[i];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderWidth = 0.3;
            btn.layer.borderColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:207.0f/255.0f alpha:1.0f].CGColor;
            btn.tag = 222 + i;
            [btn addTarget:self action:@selector(actionOfBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}


- (void)actionOfBtn:(UIButton *)button {
    
    [_delegate supplyMarketView:self supplyMarketButtonTag:button.tag - 222];
}

@end
