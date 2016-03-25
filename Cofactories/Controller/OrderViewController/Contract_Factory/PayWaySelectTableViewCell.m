

//
//  PayWaySelectTableViewCell.m
//  Cofactories
//
//  Created by GTF on 16/3/18.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PayWaySelectTableViewCell.h"

@implementation PayWaySelectTableViewCell{
    UIImageView *_imageV;
    UILabel     *_titleLB;
    UIButton    *_selBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    _imageV.layer.masksToBounds = YES;
    _imageV.layer.cornerRadius = 5;
    [self addSubview:_imageV];
    
    _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100, 40)];
    _titleLB.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLB];
    
    _selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selBtn.frame = CGRectMake(kScreenW-30, 10, 20, 20);
    _selBtn.backgroundColor = [UIColor grayColor];
    _selBtn.layer.masksToBounds = YES;
    _selBtn.layer.cornerRadius = 10;
    [_selBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selBtn];
}

- (void)setPayModel:(PayWayModel *)payModel{
    _payModel = payModel;
    
    _imageV.image = [UIImage imageNamed:payModel.imageString];
    _titleLB.text = payModel.titleString;
    if (payModel.isSelected) {
        [_selBtn setBackgroundImage:[UIImage imageNamed:@"leftBtn_Selected"] forState:UIControlStateNormal];
    }else{
        [_selBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (void)buttonClick{
    self.ReloadBlock();
}

@end
