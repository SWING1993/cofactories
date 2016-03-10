//
//  OrderList_Supplier_TVC.m
//  Cofactories
//
//  Created by GTF on 16/3/8.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "OrderList_Supplier_TVC.h"

@implementation OrderList_Supplier_TVC{
    UILabel        *_creatTimeLB;
    UILabel        *_statusLB;
    UIImageView    *_orderImage;
    UILabel        *_nameLB;
    UILabel        *_amountLB;
    UILabel        *_typeLB;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *labelImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 13, 13)];
        labelImage.image = [UIImage imageNamed:@"labelImage"];
        [self.contentView addSubview:labelImage];
        
        _creatTimeLB = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, 250, 25)];
        _creatTimeLB.textColor = [UIColor colorWithRed:177/255.0 green:177/255.0 blue:177/255.0 alpha:1.0];
        _creatTimeLB.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_creatTimeLB];
        
        _statusLB = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-50, 0, 50, 25)];
        _statusLB.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_statusLB];
        
        _orderImage= [UIImageView new];
        _orderImage.frame = CGRectMake(15, 25, 80, 65);
        [self.contentView addSubview:_orderImage];
        
        _nameLB = [[UILabel alloc] initWithFrame:CGRectMake(115, 20, kScreenW-120, 25)];
        _nameLB.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameLB];
        
        _amountLB = [[UILabel alloc] initWithFrame:CGRectMake(115, 20+25, kScreenW-120, 25)];
        _amountLB.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_amountLB];
        
        _typeLB = [[UILabel alloc] initWithFrame:CGRectMake(115, 20+25+25, kScreenW-120, 25)];
        _typeLB.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_typeLB];

    }
    return self;
}

- (void)setOrderModel:(SupplierOrderModel *)orderModel{
    _orderModel = orderModel;
    
    _creatTimeLB.text = orderModel.createdAt;
    
    if ([orderModel.status isEqualToString:@"0"]) {
        _statusLB.text = @"未完成";
        _statusLB.textColor = MAIN_COLOR;
    }else {
        _statusLB.text = @"已完成";
        _statusLB.textColor = [UIColor colorWithRed:43/255.0 green:135/255.0 blue:70/255.0 alpha:1];
    }
    if (orderModel.photoArray.count > 0) {
        [_orderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,orderModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    }else{
        _orderImage.image = [UIImage imageNamed:@"placeHolderImage"];
    }
    _nameLB.text = [NSString stringWithFormat:@"名称   %@",orderModel.name];
    _amountLB.text = [NSString stringWithFormat:@"数量   %.2f%@",orderModel.amount,orderModel.unit];
    _typeLB.text = [NSString stringWithFormat:@"类型   %@",orderModel.type];

}

@end
