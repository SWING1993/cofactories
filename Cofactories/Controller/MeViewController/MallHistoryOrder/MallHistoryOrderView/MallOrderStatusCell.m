//
//  MallOrderStatusCell.m
//  Cofactories
//
//  Created by 赵广印 on 16/2/17.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallOrderStatusCell.h"

@implementation MallOrderStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.creatTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenW - 20, 20)];
        self.creatTime.font = [UIFont systemFontOfSize:13];
        self.creatTime.textColor = [UIColor lightGrayColor];
        [self addSubview:self.creatTime];
        self.orderNum = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.creatTime.frame), kScreenW - 20, 20)];
        self.orderNum.font = [UIFont systemFontOfSize:13];
        self.orderNum.textColor = [UIColor lightGrayColor];
        [self addSubview:self.orderNum];
        self.payTime = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.orderNum.frame), kScreenW - 20, 20)];
        self.payTime.font = [UIFont systemFontOfSize:13];
        self.payTime.textColor = [UIColor lightGrayColor];
        [self addSubview:self.payTime];
        self.sendTime = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.payTime.frame), kScreenW - 20, 20)];
        self.sendTime.font = [UIFont systemFontOfSize:13];
        self.sendTime.textColor = [UIColor lightGrayColor];
        [self addSubview:self.sendTime];
        self.receiveTime = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.sendTime.frame), kScreenW - 20, 20)];
        self.receiveTime.font = [UIFont systemFontOfSize:13];
        self.receiveTime.textColor = [UIColor lightGrayColor];
        [self addSubview:self.receiveTime];
    }
    return self;
}
//购买订单编号和交易记录
- (void)reloadMallBuyHistoryOrderTimeWithMallBuyHistoryModel:(MallBuyHistoryModel *)mallBuyHistoryModel {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.creatTime.text = [NSString stringWithFormat:@"创建时间：%@", mallBuyHistoryModel.creatTime];
    self.orderNum.text = [NSString stringWithFormat:@"订单编号：%@", mallBuyHistoryModel.orderNumber];
    switch (mallBuyHistoryModel.status) {
        case 2:
            self.payTime.text = [NSString stringWithFormat:@"付款时间：%@", mallBuyHistoryModel.payTime];
            self.sendTime.hidden = YES;
            self.receiveTime.hidden = YES;
            break;
        case 3:
            self.payTime.text = [NSString stringWithFormat:@"付款时间：%@", mallBuyHistoryModel.payTime];
            self.sendTime.text = [NSString stringWithFormat:@"发货时间：%@", mallBuyHistoryModel.sendTime];
            self.receiveTime.hidden = YES;
            break;
        case 4:
            self.payTime.text = [NSString stringWithFormat:@"付款时间：%@", mallBuyHistoryModel.payTime];
            self.sendTime.text = [NSString stringWithFormat:@"发货时间：%@", mallBuyHistoryModel.sendTime];
            self.receiveTime.text = [NSString stringWithFormat:@"收货时间：%@", mallBuyHistoryModel.receiveTime];
            break;
        case 5:
            self.payTime.text = [NSString stringWithFormat:@"付款时间：%@", mallBuyHistoryModel.payTime];
            self.sendTime.text = [NSString stringWithFormat:@"发货时间：%@", mallBuyHistoryModel.sendTime];
            self.receiveTime.text = [NSString stringWithFormat:@"收货时间：%@", mallBuyHistoryModel.receiveTime];
            break;
        default:
            self.payTime.hidden = YES;
            self.sendTime.hidden = YES;
            self.receiveTime.hidden = YES;
            break;
    }
}
//出售订单编号和交易记录
- (void)reloadMallSellHistoryOrderTimeWithMallSellHistoryModel:(MallSellHistoryModel *)mallSellHistoryModel {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.creatTime.text = [NSString stringWithFormat:@"创建时间：%@", mallSellHistoryModel.creatTime];
    self.orderNum.text = [NSString stringWithFormat:@"订单编号：%@", mallSellHistoryModel.orderNumber];
    switch (mallSellHistoryModel.status) {
        case 2:
            self.payTime.text = [NSString stringWithFormat:@"付款时间：%@", mallSellHistoryModel.payTime];
            self.sendTime.hidden = YES;
            self.receiveTime.hidden = YES;
            break;
        case 3:
            self.payTime.text = [NSString stringWithFormat:@"付款时间：%@", mallSellHistoryModel.payTime];
            self.sendTime.text = [NSString stringWithFormat:@"发货时间：%@", mallSellHistoryModel.sendTime];
            self.receiveTime.hidden = YES;
            break;
        case 4:
            self.payTime.text = [NSString stringWithFormat:@"付款时间：%@", mallSellHistoryModel.payTime];
            self.sendTime.text = [NSString stringWithFormat:@"发货时间：%@", mallSellHistoryModel.sendTime];
            self.receiveTime.text = [NSString stringWithFormat:@"收货时间：%@", mallSellHistoryModel.receiveTime];
            break;
        case 5:
            self.payTime.text = [NSString stringWithFormat:@"付款时间：%@", mallSellHistoryModel.payTime];
            self.sendTime.text = [NSString stringWithFormat:@"发货时间：%@", mallSellHistoryModel.sendTime];
            self.receiveTime.text = [NSString stringWithFormat:@"收货时间：%@", mallSellHistoryModel.receiveTime];
            break;
        default:
            self.payTime.hidden = YES;
            self.sendTime.hidden = YES;
            self.receiveTime.hidden = YES;
            break;
    }
}
@end
