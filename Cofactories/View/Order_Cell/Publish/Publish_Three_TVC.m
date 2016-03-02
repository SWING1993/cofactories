//
//  Publish_Three_TVC.m
//  Cofactories
//
//  Created by GTF on 16/2/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "Publish_Three_TVC.h"

@implementation Publish_Three_TVC{
    UILabel *_titleLB;
    UIButton *_canlendarBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLB = [UILabel new];
        _titleLB.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLB];
        
        _cellTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, kScreenW-100, 40)];
        _cellTF.font = [UIFont systemFontOfSize:12];
        _cellTF.textColor = [UIColor lightGrayColor];
        [self addSubview:_cellTF];
        
        _canlendarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _canlendarBtn.frame = CGRectMake(100, 0, kScreenW-100, 40);
        _canlendarBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_canlendarBtn setTitleColor:GRAYCOLOR(190) forState:UIControlStateNormal];
        [_canlendarBtn setTitle:@"请选择订单期限" forState:UIControlStateNormal];
        [_canlendarBtn addTarget:self action:@selector(timeChangeClick) forControlEvents:UIControlEventTouchUpInside];
        _canlendarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_canlendarBtn];
        
    }
    return self;
}

- (void)loadDataWithTitleString:(NSString *)titleString
              placeHolderString:(NSString *)placeHolderString
                         isLast:(BOOL)isLast{
    if (isLast) {
        _titleLB.text = titleString;
        _titleLB.frame = CGRectMake(25, 0, 60, 40);
    }else{
        NSString *string = [NSString stringWithFormat:@"%@ %@",@"*",titleString];
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
        _titleLB.attributedText = attributedTitle;
        _titleLB.frame = CGRectMake(15, 0, 70, 40);
    }
    
    _cellTF.placeholder = placeHolderString;
    if ([_cellTF.placeholder isEqualToString:@"请填写订单数量"]) {
        _cellTF.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        _cellTF.keyboardType = UIKeyboardTypeDefault;
    }
}

- (void)setIsShowCanlendar:(BOOL)isShowCanlendar{
    _isShowCanlendar = isShowCanlendar;
    if (_isShowCanlendar) {
        _cellTF.hidden = YES;
        _canlendarBtn.hidden = NO;
    }else{
        _cellTF.hidden = NO;
        _canlendarBtn.hidden = YES;
    }
}

- (void)timeChangeClick{
    [self.delgate clickCanlendarButton:_canlendarBtn];
}

@end
