//
//  ZGYSelectNumberView.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/7.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ZGYSelectNumberView.h"

@implementation ZGYSelectNumberView  {
    NSInteger      _amount;
//    UITextField    *_amountTextfield;
}


- (id)initWithFrame:(CGRect)frame WithBeginAmount:(NSInteger)aAmount leaveCount:(NSInteger)aLeaveCount {
    if (self = [super initWithFrame:frame]) {
        
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor grayColor].CGColor;
//        self.layer.cornerRadius = 5;
        _amount = aAmount;
        self.leaveCount = aLeaveCount;
        [self addButtonAndAmountViewWithFram:frame];
        self.timeAmount = aAmount;
    }
    return self;
}

- (void)addButtonAndAmountViewWithFram:(CGRect)frame{
    
    NSArray *array = @[@"-",@"+"];
    for (int i = 0; i<array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*4*(frame.size.width/5.f), 0, frame.size.width/5.f, frame.size.width/5.f);
        button.backgroundColor = [UIColor grayColor];
        button.tag = i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    _amountTextfield = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width/5.f, 0, frame.size.width/5.f*3, frame.size.width/5.f)];
    _amountTextfield.delegate = self;
    _amountTextfield.text = [NSString stringWithFormat:@"%ld",(long)_amount];
    _amountTextfield.keyboardType = UIKeyboardTypeNumberPad;
    _amountTextfield.textAlignment = NSTextAlignmentCenter;
    _amountTextfield.textColor = [UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
    [self addSubview:_amountTextfield];
    
}

- (void)buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    _amount = [_amountTextfield.text integerValue];
    if (button.tag == 0) {
        if (_amount == 1 || _amount < 1) {
            kTipAlert(@"最少限购1件");
        }else if (_amount > 1){
            _amount--;
        }
    }else if (button.tag == 1){
        if (_amount == self.leaveCount || _amount > self.leaveCount) {
            kTipAlert(@"超出库存范围");
        } else {
           _amount++;
        }
    }
    
    _amountTextfield.text = [NSString stringWithFormat:@"%ld",(long)_amount];
    self.timeAmount = _amount;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text integerValue] == 0 ||[textField.text integerValue] < 0 ) {
        kTipAlert(@"最少限购1件");
        _amountTextfield.text = @"1";
    } else if ([textField.text integerValue] > self.leaveCount) {
        kTipAlert(@"超出库存范围");
        _amountTextfield.text = [NSString stringWithFormat:@"%ld", self.leaveCount];
    }
    _amount = [textField.text integerValue];
    self.timeAmount = [textField.text integerValue];
}

@end
