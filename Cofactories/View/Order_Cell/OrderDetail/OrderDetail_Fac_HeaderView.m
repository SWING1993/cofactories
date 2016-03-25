//
//  OrderDetail_Fac_HeaderView.m
//  Cofactories
//
//  Created by GTF on 16/3/24.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "OrderDetail_Fac_HeaderView.h"

@implementation OrderDetail_Fac_HeaderView{
    UIButton  *_orderImageBtn;
    UILabel   *_userNameLB;
    UILabel   *_userAddressLB;
    UIButton  *_chatBtn;
    UIButton  *_bidBtn;
    UILabel   *_bidLB;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    _orderImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderImageBtn.frame = CGRectMake(10, 15, 80, 60);
    [_orderImageBtn addTarget:self action:@selector(imageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_orderImageBtn];
    
    _userNameLB = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, kScreenW-110, 20)];
    _userNameLB.font = FontOfSize(14);
    [self addSubview:_userNameLB];
    
    _userAddressLB = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, kScreenW-110, 20)];
    _userAddressLB.font = FontOfSize(12);
    _userAddressLB.textColor = [UIColor grayColor];
    [self addSubview:_userAddressLB];
    
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*kScreenW/2, 90, kScreenW/2, 40);
        button.tag = i+1;
        button.userInteractionEnabled = YES;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIImageView *images = [[UIImageView alloc] initWithFrame:CGRectMake(20, 7.5, 25, 25)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenW/2)-80, 5, 60, 30)];
        label.font = FontOfSize(14);
        label.textAlignment = NSTextAlignmentCenter;
        
        if (i==0) {
            _chatBtn = button;
            images.image = [UIImage imageNamed:@"orderHeaderChat"];
            [_chatBtn addSubview:images];
            
            label.text = @"联系商家";
            [_chatBtn addSubview:label];
            
            CALayer *lineLayerTwo = [CALayer layer];
            lineLayerTwo.frame = CGRectMake(kScreenW/2, 5, 0.5, 30);
            lineLayerTwo.backgroundColor = [UIColor grayColor].CGColor;
            [_chatBtn.layer addSublayer:lineLayerTwo];
        }else{
            _bidBtn = button;
            images.image = [UIImage imageNamed:@"orderHeaderBid"];
            [_bidBtn addSubview:images];
            
            [_bidBtn addSubview:label];
            _bidLB = label;
        }
        
    }
    
    
    CALayer *lineLayerOne = [CALayer layer];
    lineLayerOne.frame = CGRectMake(0, 90, kScreenW, 0.5);
    lineLayerOne.backgroundColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:lineLayerOne];
    
    
}

- (void)setModel:(FactoryOrderMOdel *)model{
    _model = model;
    
    if (model.photoArray.count > 0) {
        [_orderImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,model.photoArray[0]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    }else{
        [_orderImageBtn setBackgroundImage:[UIImage imageNamed:@"placeHolderImage"] forState:UIControlStateNormal];
    }
}

- (void)setUserName:(NSString *)userName{
    _userName = userName;
    _userNameLB.text = userName;
}

- (void)setUserAddress:(NSString *)userAddress{
    _userAddress = userAddress;
    _userAddressLB.text = userAddress;
}

- (void)setEnterType:(NSInteger)enterType{
    _enterType = enterType;
    if (enterType == 0) {
        _bidLB.text = @"参与投标";
    }else if (enterType == 1){
        _bidLB.text = @"已投过标";
    }else if (enterType == 2){
        _bidLB.text = @"投标管理";
    }else{
        _bidLB.text = @"订单评分";
    }
}

#pragma mark - Btn
- (void)imageBtnClick{
    self.ImageBtnBlock(self.model.photoArray);
}

- (void)buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) {
        self.ChatBtnBlock();
    }else{
        self.BidBtnBlock();
    }
}

@end
