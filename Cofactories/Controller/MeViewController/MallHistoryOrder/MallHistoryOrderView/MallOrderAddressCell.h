//
//  MallHistoryOrderAddressCell.h
//  Cofactories
//
//  Created by 赵广印 on 16/2/17.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MallBuyHistoryModel.h"
#import "MallSellHistoryModel.h"

@interface MallOrderAddressCell : UITableViewCell

@property (nonatomic, strong) UIImageView *addressView;
@property (nonatomic, strong) UILabel *personName;
@property (nonatomic, strong) UILabel *personPhoneNumber;
@property (nonatomic, strong) UILabel *personAddress;

//购买订单
- (void)reloadReceiveAddressWithMallBuyHistoryModel:(MallBuyHistoryModel *)mallBuyHistoryModel;

//出售订单
- (void)reloadReceiveAddressWithMallSellHistoryModel:(MallSellHistoryModel *)mallSellHistoryModel;

@end
