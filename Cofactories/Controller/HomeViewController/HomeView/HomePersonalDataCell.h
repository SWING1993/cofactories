//
//  HomePersonalDataCell.h
//  Cofactories
//
//  Created by 赵广印 on 15/11/21.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePersonalDataCell : UITableViewCell

@property (nonatomic, strong) UIImageView *personalDataLeftImage, *personalDataMiddleImage, *personalDataRightImage;
@property (nonatomic, strong) UILabel *personNameLabel, *personStatusLabel, *personWalletLeft, *personAddressLabel;//个人资料（名字，钱包余额，用户类型，地址）
@property (nonatomic, strong) UILabel *personStyleLabel;//个人身份
@property (nonatomic, strong) UILabel *authenticationLabel;//是否是认证用户

@property (nonatomic, strong) UIButton *authenticationButton;

@end
