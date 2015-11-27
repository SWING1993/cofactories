//
//  ZGYSelectButtonView.m
//  SBButtonSelect
//
//  Created by 赵广印 on 15/11/26.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "ZGYSelectButtonView.h"

#define kColor [UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f]
#define kButtonWidth kScreenW/4
#define kHeight 30
#define kBorderWidth 0.3
#define kMargin 10*kZGY

@implementation ZGYSelectButtonView
@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        array4Btn = [NSMutableArray arrayWithCapacity:0];
        UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kBorderWidth, kScreenW, kBorderWidth)];
        bottomLineLabel.backgroundColor = kColor;
        [self addSubview:bottomLineLabel];
        NSArray *array = @[@"男装", @"女装", @"童装", @"面料"];
        for (int i = 0; i < 4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i+ 1;
            btn.frame = CGRectMake(i*kButtonWidth, 0, kButtonWidth, kHeight);
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:kColor forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn addTarget:self action:@selector(actionOfBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            if (btn.tag == 1) {
                btn.selected = YES;
                selectLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 0, 0.3, kHeight)];
                selectLabel1.backgroundColor = kColor;
                [self addSubview:selectLabel1];
                selectLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 0, kScreenW/4 - 2*kMargin, 0.3)];
                selectLabel2.backgroundColor = kColor;
                [self addSubview:selectLabel2];
                selectLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW/4 - 0.3 - kMargin, 0, 0.3, kHeight)];
                selectLabel3.backgroundColor = kColor;
                [self addSubview:selectLabel3];
                selectLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, self.frame.size.height - 0.5, kScreenW /4 - 2*kMargin, 1)];
                selectLabel4.backgroundColor = [UIColor whiteColor];
                [self addSubview:selectLabel4];
            }
            [array4Btn addObject:btn];
        }
    }
    return self;
}

- (void)actionOfBtn:(UIButton *)btn {

    [_delegate selectButtonView:self selectButtonTag:btn.tag];
    btn.selected = YES;
    for (UIButton *sunbBtn in array4Btn) {
        if (sunbBtn != btn) {
            sunbBtn.selected = NO;
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        selectLabel1.frame = CGRectMake(btn.frame.origin.x + kMargin, 0, 0.3, kHeight);
        selectLabel2.frame = CGRectMake(btn.frame.origin.x + kMargin, 0, btn.frame.size.width - 2*kMargin, 0.3);
        selectLabel3.frame = CGRectMake(CGRectGetMaxX(btn.frame) - 0.3 - kMargin, 0, 0.3, kHeight);
        selectLabel4.frame = CGRectMake(btn.frame.origin.x + kMargin, kHeight - 0.7, btn.frame.size.width - 2*kMargin, 1);
    }];
}

@end
