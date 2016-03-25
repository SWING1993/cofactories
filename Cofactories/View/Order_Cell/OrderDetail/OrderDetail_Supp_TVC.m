//
//  OrderDetail_Supp_TVC.m
//  Cofactories
//
//  Created by GTF on 16/3/22.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "OrderDetail_Supp_TVC.h"

@implementation OrderDetail_Supp_TVC{
    UILabel *_orderIdlB;
    UILabel *_orderTypeLB;
    UILabel *_orderTitleLB;
    UILabel *_orderAmountLB;
    UILabel *_orderCreatTimeLB;
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
    
    for (int i = 0; i<5; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 40+i*25, 50, 25)];
        label.font = FontOfSize(12);
        label.text = @[@"类型",@"名称",@"数量",@"下单时间",@"备注信息"][i];
        [self.contentView addSubview:label];
        
        UILabel *lb = [UILabel new];
        lb.font = FontOfSize(12);
        lb.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:lb];
        
        switch (i) {
            case 0:
                _orderTypeLB = lb;
                _orderTypeLB.frame = CGRectMake(80, 40, kScreenW-90, 25);
                break;
            case 1:
                _orderTitleLB = lb;
                _orderTitleLB.frame = CGRectMake(80, 40+25, kScreenW-90, 25);
                break;
            case 2:
                _orderAmountLB = lb;
                _orderAmountLB.frame = CGRectMake(80, 40+50, kScreenW-90, 25);
                break;
            case 3:
                _orderCreatTimeLB = lb;
                _orderCreatTimeLB.frame = CGRectMake(80, 40+75, kScreenW-90, 25);
                break;
            case 4:
                _commentLB = lb;
                _commentLB.numberOfLines = 0;
                break;
            default:
                break;
        }
    }
}

- (void)setModel:(SupplierOrderModel *)model{
    _model = model;
    
    _orderIdlB.text = [NSString stringWithFormat:@"订单编号: %@",model.ID];
    _orderTypeLB.text = model.type;
    _orderTitleLB.text = model.name;
    _orderAmountLB.text = [NSString stringWithFormat:@"%.2f%@",model.amount,model.unit];
    _orderCreatTimeLB.text = model.createdAt;

    CGSize textSize=[model.descriptions boundingRectWithSize:CGSizeMake(kScreenW-90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size;
    _commentLB.text = model.descriptions;
    _commentLB.frame = CGRectMake(80, 145, textSize.width, textSize.height);

}

@end
