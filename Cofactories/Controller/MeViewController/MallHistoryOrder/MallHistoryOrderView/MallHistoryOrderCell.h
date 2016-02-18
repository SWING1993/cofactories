//
//  MallHistoryOrderCell.h
//  Cofactories
//
//  Created by 赵广印 on 16/1/30.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

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
@end
