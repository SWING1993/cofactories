//
//  MallHistoryOrderCell.h
//  Cofactories
//
//  Created by 赵广印 on 16/1/30.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MallBuyHistoryModel.h"
#import "MallSellHistoryModel.h"

@interface MallHistoryOrderCell : UITableViewCell

@property (nonatomic, strong) UILabel *goodsStatus;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *goodsTitle;
@property (nonatomic, strong) UILabel *goodsCategory;
@property (nonatomic, strong) UILabel *goodsPrice;
@property (nonatomic, strong) UILabel *goodsNumber;
@property (nonatomic, strong) UILabel *totalPrice;
@property (nonatomic, strong) UIButton *changeStatus;
@property (nonatomic, assign) BOOL showButton;

//购买历史记录列表
- (void)reloadMallBuyHistoryOrderDataWithMallBuyHistoryModel:(MallBuyHistoryModel *)mallBuyHistoryModel;
//出售历史记录列表
- (void)reloadMallSellHistoryOrderDataWithMallSellHistoryModel:(MallSellHistoryModel *)mallSellHistoryModel;


//购买历史记录某个订单详情
- (void)reloadMallBuyHistoryOrderDetailDataWithMallBuyHistoryModel:(MallBuyHistoryModel *)mallBuyHistoryModel;
//出售历史记录某个订单详情
- (void)reloadMallSellHistoryOrderDetailDataWithMallSellHistoryModel:(MallSellHistoryModel *)mallSellHistoryModel;

@end
