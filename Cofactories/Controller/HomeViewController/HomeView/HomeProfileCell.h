//
//  HomeProfileCell.h
//  Cofactories
//
//  Created by 赵广印 on 16/3/21.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

@interface HomeProfileCell : UITableViewCell

@property (nonatomic, strong) UIImageView *personPhoto, *stylePhoto;
@property (nonatomic, strong) UILabel *personName, *personScore, *personWallet, *personStyle;
@property (nonatomic, strong) UILabel *personAddress;
@property (nonatomic, strong) UIButton *changeAddressBtn;
@property (nonatomic, strong) UIButton *verifyPhoto;
@property (nonatomic, strong) UILabel *verifyLabel;

- (void)reloadDataWithUserModel:(UserModel *)userModel wallet:(CGFloat)wallet;

@end
