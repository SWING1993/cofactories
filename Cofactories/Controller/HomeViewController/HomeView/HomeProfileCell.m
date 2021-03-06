//
//  HomeProfileCell.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/21.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "HomeProfileCell.h"
#import "UserModel.h"

#define kPersonPhotoHeight 60*kZGY
#define kPersonPhotoMargin 20*kZGY
#define kVerifyPhotoHeight 40*kZGY


@implementation HomeProfileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.personPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(kPersonPhotoMargin, kPersonPhotoMargin, kPersonPhotoHeight, kPersonPhotoHeight)];
        self.personPhoto.contentMode = UIViewContentModeScaleAspectFill;
        self.personPhoto.layer.cornerRadius = kPersonPhotoHeight/2;
        self.personPhoto.clipsToBounds = YES;
        [self addSubview:self.personPhoto];
        
        self.stylePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(kPersonPhotoHeight + 2*kPersonPhotoMargin, 12.5*kZGY, 15*kZGY, 15*kZGY)];
        [self addSubview:self.stylePhoto];
        
        self.personName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.stylePhoto.frame) + 5*kZGY, 10*kZGY, kScreenW - 4*kPersonPhotoMargin - kPersonPhotoHeight - kVerifyPhotoHeight - 15*kZGY, 20*kZGY)];
        self.personName.font = [UIFont systemFontOfSize:12*kZGY];
        [self addSubview:self.personName];
        
        for (int i = 0; i < 4; i++) {
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.stylePhoto.frame), CGRectGetMaxY(self.stylePhoto.frame) + i*15*kZGY + 3*kZGY, kScreenW - 4*kPersonPhotoMargin - kPersonPhotoHeight - kVerifyPhotoHeight, 15*kZGY)];
            myLabel.font = [UIFont systemFontOfSize:11*kZGY];
            myLabel.textColor = GRAYCOLOR(153);
            switch (i) {
                case 0:
                    self.personScore = myLabel;
                    break;
                case 1:
                    self.personWallet = myLabel;
                    break;
                case 2:
                    self.personStyle = myLabel;
                    break;
                case 3:
                    self.personAddress = myLabel;
                    break;
                default:
                    break;
            }
            [self addSubview:myLabel];
        }
        
        self.changeAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.changeAddressBtn.frame = CGRectMake(CGRectGetMinX(self.personScore.frame), CGRectGetMaxY(self.personScore.frame), kScreenW - 4*kPersonPhotoMargin - kPersonPhotoHeight - kVerifyPhotoHeight, 50*kZGY);
        self.changeAddressBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:self.changeAddressBtn];
        
        self.verifyPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        self.verifyPhoto.frame = CGRectMake(kScreenW - kVerifyPhotoHeight - kPersonPhotoMargin - 5*kZGY, kPersonPhotoMargin, kVerifyPhotoHeight, kVerifyPhotoHeight);
        [self addSubview:self.verifyPhoto];
        
        self.verifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - kVerifyPhotoHeight - kPersonPhotoMargin - 10*kZGY, CGRectGetMaxY(self.verifyPhoto.frame) + 10*kZGY, kVerifyPhotoHeight + 10*kZGY, 20*kZGY)];
        self.verifyLabel.font = [UIFont systemFontOfSize:12*kZGY];
        self.verifyLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.verifyLabel];
        
    }
    return self;
}

- (void)reloadDataWithUserModel:(UserModel *)userModel wallet:(CGFloat)wallet {
    //用户头像
    [self.personPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI, userModel.uid]] placeholderImage:[UIImage imageNamed:@"headBtn"]];
    //用户名字
    if (userModel.name.length) {
        self.personName.text = userModel.name;
    }
    //用户积分
    if (userModel.score.length) {
        self.personScore.text = [NSString stringWithFormat:@"积分：%@", userModel.score];
    }
    //钱包余额
    self.personWallet.text = [NSString stringWithFormat:@"余额：%.2f元", wallet];
    //用户类型
    if (userModel.enterpriseType == EnterpriseType_noEnterprise) {
        if ([userModel.verified isEqualToString:@"0"] || [userModel.verified isEqualToString:@"暂无"]) {
            self.stylePhoto.image = [UIImage imageNamed:@"注"];
        } else if ([userModel.verified isEqualToString:@"1"]) {
            self.stylePhoto.image = [UIImage imageNamed:@"证"];
        }
    } else {
        self.stylePhoto.image = [UIImage imageNamed:@"企"];
    }
    //用户身份
    self.personStyle.text = [NSString stringWithFormat:@"个人身份：%@", [UserModel getRoleWith:userModel.UserType]];
    //地址
    
    if ([userModel.address isEqualToString:@"暂无"] || [Tools isBlankString:userModel.address] == YES) {
        self.personAddress.text = @"地址暂无，点击完善个人资料";
    } else {
        self.personAddress.text = userModel.address;
    }
    
    //认证状态
    switch (userModel.verify_status) {
        case 0:
            self.verifyLabel.text = @"前往认证";
            [self.verifyPhoto setImage:[UIImage imageNamed:@"Home-verifying"] forState:UIControlStateNormal];
            break;
        case 1:
            self.verifyLabel.text = @"正在审核";
            [self.verifyPhoto setImage:[UIImage imageNamed:@"Home-verifying"] forState:UIControlStateNormal];
            break;
        case 2:
            self.verifyLabel.text = @"已认证";
            [self.verifyPhoto setImage:[UIImage imageNamed:@"Home-verifyed"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}


@end
