//
//  ProcessingOrder_TVC.m
//  Cofactories
//
//  Created by GTF on 15/12/3.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ProgressingOrder_TVC.h"

@implementation ProgressingOrder_TVC{
    UIImageView    *_labelImage;
    UILabel        *_creatTimeLB;
    UIImageView    *_bgImage;
    UILabel        *_typeLB;
    UILabel        *_gpLB;
    UIImageView    *_restrictImage;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _labelImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 13, 13)];
        _labelImage.image = [UIImage imageNamed:@"labelImage"];
        [self.contentView addSubview:_labelImage];
        
        _creatTimeLB = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, 200, 25)];
        _creatTimeLB.textColor = [UIColor colorWithRed:177/255.0 green:177/255.0 blue:177/255.0 alpha:1.0];
        _creatTimeLB.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_creatTimeLB];
        
        _bgImage = [UIImageView new];
        _bgImage.frame = CGRectMake(15, 25, 80, 65);
        _bgImage.layer.masksToBounds = YES;
        _bgImage.layer.cornerRadius = 5;
        [self.contentView addSubview:_bgImage];
        
        _typeLB = [[UILabel alloc] initWithFrame:CGRectMake(115, 25, 120, 25)];
        _typeLB.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_typeLB];
        
        _gpLB = [[UILabel alloc] initWithFrame:CGRectMake(115, 50, 120, 25)];
        _gpLB.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_gpLB];
        
        _restrictImage = [[UIImageView alloc] init];
        _restrictImage.frame = CGRectMake(115, 78, 50, 15);
        _restrictImage.image = [UIImage imageNamed:@"限制订单"];
        [self.contentView addSubview:_restrictImage];

    }
    return self;
}

- (void)laoutWithDataModel:(ProcessingAndComplitonOrderModel *)dataModel userModel:(UserModel *)userModel{
    _creatTimeLB.text = dataModel.createdAt;
    
    if (dataModel.photoArray.count > 0) {
        [_bgImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,dataModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    }else{
        _bgImage.image = [UIImage imageNamed:@"placeHolderImage"];
    }
    
    if ([dataModel.orderType isEqualToString:@"投标订单"]) {
        switch (userModel.UserType) {
            case UserType_supplier:
                _typeLB.text = @"类型:   供应商订单";
                break;
            case UserType_designer:
                _typeLB.text = @"类型:   设计师订单";
                break;
            case UserType_processing:
                _typeLB.text = @"类型:   加工订单";
                break;

            default:
                break;
        }
        _gpLB.text = @"已投标订单";
        _gpLB.textColor = MAIN_COLOR;
    }else{
        _typeLB.text = [NSString stringWithFormat:@"类型:   %@",dataModel.orderType];
        _gpLB.text = @"已发布订单";
        _gpLB.textColor = [UIColor colorWithRed:30/255.0 green:166/255.0 blue:73/255.0 alpha:1];
    }
    
    _restrictImage.hidden = NO;
}
@end
