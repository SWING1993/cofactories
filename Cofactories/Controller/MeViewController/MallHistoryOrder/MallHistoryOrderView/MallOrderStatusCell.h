//
//  MallOrderStatusCell.h
//  Cofactories
//
//  Created by 赵广印 on 16/2/17.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MallBuyHistoryModel.h"
#import "MallSellHistoryModel.h"

@interface MallOrderStatusCell : UITableViewCell

@property (nonatomic, strong) UILabel *creatTime;
@property (nonatomic, strong) UILabel *orderNum;
@property (nonatomic, strong) UILabel *payTime;
@property (nonatomic, strong) UILabel *sendTime;
@property (nonatomic, strong) UILabel *receiveTime;

//购买订单编号和交易记录
- (void)reloadMallBuyHistoryOrderTimeWithMallBuyHistoryModel:(MallBuyHistoryModel *)mallBuyHistoryModel;
//出售订单编号和交易记录
- (void)reloadMallSellHistoryOrderTimeWithMallSellHistoryModel:(MallSellHistoryModel *)mallSellHistoryModel;

@end
