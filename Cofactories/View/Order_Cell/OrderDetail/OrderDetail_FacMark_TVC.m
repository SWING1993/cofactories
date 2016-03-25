//
//  OrderDetail_FacMark_TVC.m
//  Cofactories
//
//  Created by GTF on 16/3/25.
//  Copyright © 2016年 Cofactorios. All rights reserved.


// 评分进入

#import "OrderDetail_FacMark_TVC.h"

@implementation OrderDetail_FacMark_TVC{
    UILabel *_orderIdlB;
    UILabel *_orderTypeLB;
    UILabel *_orderAmountLB;
    UILabel *_orderCreatTimeLB;
    UILabel *_orderDeadTimeLB;
    UILabel *_winnerNameLB;
    UILabel *_winnerPhoneLB;
    UILabel *_orderMoneyTitle;
    UILabel *_orderMoneyLB;
    UILabel *_commentTitle;
    UILabel *_commentLB;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 15, 20)];
    imageView.image = [UIImage imageNamed:@"dd.png"];
    [self.contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 80, 20)];
    label.textColor = MAIN_COLOR;
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"订单信息";
    [self.contentView addSubview:label];
    
    _orderIdlB = [[UILabel alloc] initWithFrame:CGRectMake(120, 15, kScreenW-130, 20)];
    _orderIdlB.textColor = [UIColor grayColor];
    _orderIdlB.textAlignment = NSTextAlignmentRight;
    _orderIdlB.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_orderIdlB];
    
    for (int i = 0; i<8; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 40+i*25, 60, 25)];
        label.font = FontOfSize(12);
        label.text = @[@"类型",@"数量",@"下单时间",@"交货日期",@"中标者",@"中标者电话",@"担保金额",@"备注信息"][i];
        [self.contentView addSubview:label];
        
        UILabel *lb = [UILabel new];
        lb.font = FontOfSize(12);
        lb.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:lb];
        
        switch (i) {
            case 0:
                _orderTypeLB = lb;
                _orderTypeLB.frame = CGRectMake(90, 40, kScreenW-100, 25);
                break;
            case 1:
                _orderAmountLB = lb;
                _orderAmountLB.frame = CGRectMake(90, 40+25, kScreenW-100, 25);
                break;
            case 2:
                _orderCreatTimeLB = lb;
                _orderCreatTimeLB.frame = CGRectMake(90, 40+50, kScreenW-100, 25);
                break;
            case 3:
                _orderDeadTimeLB = lb;
                _orderDeadTimeLB.frame = CGRectMake(90, 40+75, kScreenW-100, 25);
                break;
            case 4:
                _winnerNameLB = lb;
                _winnerNameLB.frame = CGRectMake(90, 40+100, kScreenW-100, 25);
                break;
            case 5:
                _winnerPhoneLB = lb;
                _winnerPhoneLB.frame = CGRectMake(90, 40+125, kScreenW-100, 25);
                break;
            case 6:
                _orderMoneyLB = lb;
                _orderMoneyTitle = label;
                break;
                
            case 7:
                _commentLB = lb;
                _commentLB.numberOfLines = 0;
                _commentTitle = label;
                break;
            default:
                break;
        }
    }
}

- (void)setIsRestrict:(BOOL)isRestrict{
    _isRestrict = isRestrict;
}

- (void)setModel:(FactoryOrderMOdel *)model{
    _model = model;
    
    _orderIdlB.text = [NSString stringWithFormat:@"订单编号: %@",model.ID];
    _orderTypeLB.text = model.type;
    _orderAmountLB.text = model.amount;
    _orderCreatTimeLB.text = model.createdAt;
    _orderDeadTimeLB.text = model.deadline;
    _winnerNameLB.text = model.winnerName;
    _winnerPhoneLB.text = model.winnerPhone;
    _orderMoneyLB.text = model.creditMoney;
    
    CGSize textSize=[model.descriptions boundingRectWithSize:CGSizeMake(kScreenW-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size;
    _commentLB.text = model.descriptions;
    
    if (_isRestrict) {
        _orderMoneyLB.frame = CGRectMake(90, 40+150, kScreenW-90, 25);
        _commentLB.frame = CGRectMake(90, 40+175+5, textSize.width, textSize.height);
        
    }else{
        [_orderMoneyLB removeFromSuperview];
        [_orderMoneyTitle removeFromSuperview];
        
        _commentTitle.frame = CGRectMake(15, 40+150, 60, 25);
        _commentLB.frame = CGRectMake(90, 40+150+5, textSize.width, textSize.height);
    }
}
@end
