//
//  Order_Factory_TVC.m
//  Cofactories
//
//  Created by GTF on 15/11/30.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "Order_Factory_TVC.h"

@implementation Order_Factory_TVC{
    UIImageView    *_labelImage;
    UILabel        *_creatTimeLB;
    UILabel        *_statusLB;
    UILabel        *_typeLB;
    UILabel        *_amountLB;
    UILabel        *_deadlineLB;

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
        
        _statusLB = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-50, 0, 50, 25)];
        _statusLB.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_statusLB];
        
        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imageButton.frame = CGRectMake(15, 25, 80, 65);
        self.imageButton.layer.masksToBounds = YES;
        self.imageButton.layer.cornerRadius = 5;
        [self.contentView addSubview:self.imageButton];
        
        _typeLB = [[UILabel alloc] initWithFrame:CGRectMake(115, 20, 120, 25)];
        _typeLB.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_typeLB];
        
        _amountLB = [[UILabel alloc] initWithFrame:CGRectMake(115, 20+25, 120, 25)];
        _amountLB.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_amountLB];
        
        _deadlineLB = [[UILabel alloc] initWithFrame:CGRectMake(115, 20+25+25, 120, 25)];
        _deadlineLB.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_deadlineLB];
    }
    return self;
}


- (void)laoutWithDataModel:(FactoryOrderMOdel *)dataModel{
    _creatTimeLB.text = dataModel.createdAt;
    
    if ([dataModel.status isEqualToString:@"0"]) {
        _statusLB.text = @"未完成";
        _statusLB.textColor = MAIN_COLOR;
    }else {
        _statusLB.text = @"已完成";
        _statusLB.textColor = [UIColor colorWithRed:43/255.0 green:135/255.0 blue:70/255.0 alpha:1];
    }
    if (dataModel.photoArray.count > 0) {
   [_imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,dataModel.photoArray[0]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    }else{
        [_imageButton setBackgroundImage:[UIImage imageNamed:@"placeHolderImage"] forState:UIControlStateNormal];
    }
     _typeLB.text = [NSString stringWithFormat:@"类型   %@",dataModel.type];
    _amountLB.text = [NSString stringWithFormat:@"数量   %@",dataModel.amount];
    _deadlineLB.text = [NSString stringWithFormat:@"期限   %@",dataModel.deadline];
        
}

@end
