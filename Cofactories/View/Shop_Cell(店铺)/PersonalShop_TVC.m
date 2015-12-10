//
//  PersonalShop_TVC.m
//  Cofactories
//
//  Created by GTF on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "PersonalShop_TVC.h"

@implementation PersonalShop_TVC{
    UIImageView *_imageLeft;
    UIImageView *_imageRight;
    UILabel     *_nameLBLeft;
    UILabel     *_nameLBRight;
    UILabel     *_priceLBLeft;
    UILabel     *_priceLBRight;
    UILabel     *_salesLBLeft;
    UILabel     *_salesLBRight;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];

        for (int i = 0; i<2; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*((kScreenW-10)/2.f+10), 0, (kScreenW-10)/2.f, (kScreenW-10)/2.f+60);
            button.backgroundColor = [UIColor whiteColor];
            button.userInteractionEnabled = YES;
            [self addSubview:button];
            
            if (i == 0) {
                _buttonLeft = button;
            }else{
                _buttonRight = button;
            }
        }
        
        _imageLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenW-10)/2.f, (kScreenW-10)/2.f)];
        [_buttonLeft addSubview:_imageLeft];
        _nameLBLeft = [[UILabel alloc] initWithFrame:CGRectMake(10, (kScreenW-10)/2.f+10, (kScreenW-10)/2.f-20, 25)];
        _nameLBLeft.font = [UIFont systemFontOfSize:14];
        [_buttonLeft addSubview:_nameLBLeft];
        _priceLBLeft = [[UILabel alloc] initWithFrame:CGRectMake(10, (kScreenW-10)/2.f+10+25, 50, 25)];
        _priceLBLeft.font = [UIFont systemFontOfSize:14];
        _priceLBLeft.textColor = [UIColor redColor];
        [_buttonLeft addSubview:_priceLBLeft];
        _salesLBLeft = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_buttonLeft.frame)-90, (kScreenW-10)/2.f+10+25, 80, 25)];
        _salesLBLeft.font = [UIFont systemFontOfSize:12.f];
        _salesLBLeft.textColor = [UIColor grayColor];
        _salesLBLeft.textAlignment = NSTextAlignmentRight;
        [_buttonLeft addSubview:_salesLBLeft];

        
        _imageRight = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenW-10)/2.f, (kScreenW-10)/2.f)];
        [_buttonRight addSubview:_imageRight];
        _nameLBRight = [[UILabel alloc] initWithFrame:CGRectMake(10, (kScreenW-10)/2.f+10, (kScreenW-10)/2.f-20, 25)];
        _nameLBRight.font = [UIFont systemFontOfSize:14];
        [_buttonRight addSubview:_nameLBRight];
        _priceLBRight = [[UILabel alloc] initWithFrame:CGRectMake(10, (kScreenW-10)/2.f+10+25, 50, 25)];
        _priceLBRight.font = [UIFont systemFontOfSize:14];
        _priceLBRight.textColor = [UIColor redColor];
        [_buttonRight addSubview:_priceLBRight];
        _salesLBRight = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_buttonRight.frame)-90, (kScreenW-10)/2.f+10+25, 80, 25)];
        _salesLBRight.font = [UIFont systemFontOfSize:12.f];
        _salesLBRight.textColor = [UIColor grayColor];
        _salesLBRight.textAlignment = NSTextAlignmentRight;
        [_buttonRight addSubview:_salesLBRight];
    }
    return self;
}

- (void)layoutDataWithArray:(NSArray *)array indexPath:(NSIndexPath *)indexPath{
    
    if (array.count%2 == 0) {
        
        PersonalShop_Model *modelLeft = array[2*indexPath.row];
        PersonalShop_Model *modelRight = array[2*indexPath.row+1];
        _nameLBLeft.text = modelLeft.goodsName;
        _priceLBLeft.text = [NSString stringWithFormat:@"￥%@",modelLeft.goodsPrice];
        _salesLBLeft.text = [NSString stringWithFormat:@"%@人付款",modelLeft.goodsSales];
        if (modelLeft.photoArray.count == 0) {
            _imageLeft.image = [UIImage imageNamed:@"默认图片"];
        }else{
           [_imageLeft sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,modelLeft.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
        }
        
        _nameLBRight.text = modelRight.goodsName;
        _priceLBRight.text = [NSString stringWithFormat:@"￥%@",modelRight.goodsPrice];
        _salesLBRight.text = [NSString stringWithFormat:@"%@人付款",modelRight.goodsSales];
        if (modelRight.photoArray.count == 0) {
            _imageRight.image = [UIImage imageNamed:@"默认图片"];
        }else{
            [_imageRight sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,modelRight.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
        }

        
    }else {
        if (indexPath.row != (array.count/2)) {
            PersonalShop_Model *modelLeft = array[2*indexPath.row];
            PersonalShop_Model *modelRight = array[2*indexPath.row+1];
            _nameLBLeft.text = modelLeft.goodsName;
            _priceLBLeft.text = [NSString stringWithFormat:@"￥%@",modelLeft.goodsPrice];
            _salesLBLeft.text = [NSString stringWithFormat:@"%@人付款",modelLeft.goodsSales];
            if (modelLeft.photoArray.count == 0) {
                _imageLeft.image = [UIImage imageNamed:@"默认图片"];
            }else{
                [_imageLeft sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,modelLeft.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
            }
            
            _nameLBRight.text = modelRight.goodsName;
            _priceLBRight.text = [NSString stringWithFormat:@"￥%@",modelRight.goodsPrice];
            _salesLBRight.text = [NSString stringWithFormat:@"%@人付款",modelRight.goodsSales];
            if (modelRight.photoArray.count == 0) {
                _imageRight.image = [UIImage imageNamed:@"默认图片"];
            }else{
                [_imageRight sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,modelRight.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
            }
            

        }else{
            PersonalShop_Model *modelLeft = array[2*indexPath.row];
            _nameLBLeft.text = modelLeft.goodsName;
            _priceLBLeft.text = [NSString stringWithFormat:@"￥%@",modelLeft.goodsPrice];
            _salesLBLeft.text = [NSString stringWithFormat:@"%@人付款",modelLeft.goodsSales];
            if (modelLeft.photoArray.count == 0) {
                _imageLeft.image = [UIImage imageNamed:@"默认图片"];
            }else{
                [_imageLeft sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,modelLeft.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
            }
            
            [_buttonRight removeFromSuperview];
            
        }

    }
    
    _buttonLeft.tag = 2*indexPath.row;
    _buttonRight .tag = 2*indexPath.row+1;
    
}
@end
