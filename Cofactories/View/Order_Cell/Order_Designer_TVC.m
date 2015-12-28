//
//  Order_Designer_TVC.m
//  Cofactories
//
//  Created by GTF on 15/12/2.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "Order_Designer_TVC.h"

@implementation Order_Designer_TVC{
    UIImageView    *_labelImage;
    UILabel        *_creatTimeLB;
    UILabel        *_statusLB;
    UILabel        *_titleLB;
    CALayer        *_lineLayer;
    UILabel        *_orderPhotoLB;
    UIImageView    *_orderImageOne;
    UIImageView    *_orderImageTwo;
    UIImageView    *_orderImageThree;
    UILabel        *_commentLB;

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
        
        _titleLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, kScreenW-30, 25)];
        _titleLB.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_titleLB];
        
        _lineLayer = [CALayer layer];
        _lineLayer.frame = CGRectMake(15, 50, kScreenW-30, 1);
        _lineLayer.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.f].CGColor;
        [self.contentView.layer addSublayer:_lineLayer];
        
        _orderPhotoLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 53, 60, 25)];
        _orderPhotoLB.font = [UIFont systemFontOfSize:12];
        _orderPhotoLB.text =@"订单照片";
        [self.contentView addSubview:_orderPhotoLB];
        
        for (int i = 0; i<3; i++) {
            UIImageView *orderImage = [[UIImageView alloc] initWithFrame:CGRectMake(72+i*82, 62, 72, 54)];
            orderImage.layer.masksToBounds = YES;
            orderImage.layer.cornerRadius = 5;
            [self.contentView addSubview:orderImage];
            switch (i) {
                case 0:
                    _orderImageOne = orderImage;
                    break;
                case 1:
                    _orderImageTwo = orderImage;
                    break;
                case 2:
                    _orderImageThree = orderImage;
                    break;
                default:
                    break;
            }
        }
        
        _commentLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 125, kScreenW-30, 25)];
        _commentLB.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_commentLB];


    }
    return self;
}

- (void)laoutWithDataModel:(DesignOrderModel *)dataModel{
    
    _creatTimeLB.text = dataModel.createdAt;
    if ([dataModel.status isEqualToString:@"0"]) {
        _statusLB.text = @"未完成";
        _statusLB.textColor = MAIN_COLOR;
    }else {
        _statusLB.text = @"已完成";
        _statusLB.textColor = [UIColor colorWithRed:43/255.0 green:135/255.0 blue:70/255.0 alpha:1];
    }
    _titleLB.text = [NSString stringWithFormat:@"标题          %@",dataModel.name];
    _commentLB.text = [NSString stringWithFormat:@"备注          %@",dataModel.descriptions];
    
    switch (dataModel.photoArray.count) {
        case 0:
            _orderImageOne.image = [UIImage imageNamed:@"placeHolderImage"];
            _orderImageTwo.image = nil;
            _orderImageThree.image = nil;
            break;
            
        case 1:
            [_orderImageOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,dataModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
            _orderImageTwo.image = nil;
            _orderImageThree.image = nil;

            break;

        case 2:
            [_orderImageOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,dataModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
            [_orderImageTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,dataModel.photoArray[1]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
            _orderImageThree.image = nil;
            break;

        default:
            [_orderImageOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,dataModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
            [_orderImageTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,dataModel.photoArray[1]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
            [_orderImageThree sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,dataModel.photoArray[2]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
            break;
    }
    
    
    DLog(@"%@>>++==%lu",dataModel.descriptions,(unsigned long)dataModel.photoArray.count);

}

@end
