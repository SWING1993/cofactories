//
//  CustomeView.m
//  ChuangKe
//
//  Created by GTF on 15/11/28.
//  Copyright © 2015年 GUY. All rights reserved.
//

#import "CustomeView.h"

@implementation CustomeView{
    UILabel       *_amountLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.cornerRadius = 5;
        [self addButtonAndAmountViewWithFram:frame];
        self.moneyAmount = 1000;
    }
    return self;
}

- (void)addButtonAndAmountViewWithFram:(CGRect)frame{
    
    NSArray *array = @[@"-",@"+"];
    for (int i = 0; i<array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*5*(frame.size.width/6.f), 0, frame.size.width/6.f, frame.size.width/6.f);
        button.backgroundColor = [UIColor grayColor];
        button.tag = i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/6.f, 0, frame.size.width-frame.size.width/3.f, frame.size.width/6.f)];
    _amountLabel.textAlignment = NSTextAlignmentCenter;
    _amountLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_amountLabel];
    
}

- (void)setAmount:(NSInteger)amount{
    _amount = amount;
    _amountLabel.text = [NSString stringWithFormat:@"%ld 元",(long)amount];
}

- (void)buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 0) {
        if (_amount == 1000) {
        }else if (_amount > 1000){
            _amount-=500;
        }
    }else if (button.tag == 1){
        _amount+=500;
    }
    
    _amountLabel.text = [NSString stringWithFormat:@"%ld 元",(long)_amount];
    self.moneyAmount = _amount;
    
    self.MoneyBlock(_amount);
}


@end
