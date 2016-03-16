//
//  OrderDetail_Design_TVC.m
//  Cofactories
//
//  Created by GTF on 16/3/16.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "OrderDetail_Design_TVC.h"

@implementation OrderDetail_Design_TVC{
    UILabel *_orderIdlB;
    UILabel *_orderTitleLB;
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
    
    for (int i = 0; i<2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 40+i*25, 40, 25)];
        label.font = FontOfSize(12);
        label.text = @[@"标题",@"备注"][i];
        [self.contentView addSubview:label];
        
        UILabel *lb = [UILabel new];
        lb.font = FontOfSize(12);
        [self.contentView addSubview:lb];
        if (i==0) {
            _orderTitleLB = lb;
            _orderTitleLB.frame = CGRectMake(80, 40, kScreenW-90, 25);
        }else{
            _commentLB = lb;
            _commentLB.numberOfLines = 0;
        }
    }
}

- (void)setModel:(DesignOrderModel *)model{
    _model = model;
    
    _orderIdlB.text = [NSString stringWithFormat:@"订单编号: %@",model.ID];
    _orderTitleLB.text = model.name;
    
    CGSize size = [Tools getSize:model.descriptions andFontOfSize:12 andWidthMake:kScreenW-90];
    _commentLB.frame = CGRectMake(80, 70, kScreenW-90, size.height);
    _commentLB.text = model.descriptions;
}

@end
