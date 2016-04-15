//
//  PersonalWorks_TVC.m
//  Cofactories
//
//  Created by GTF on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "PersonalWorks_TVC.h"

@implementation PersonalWorks_TVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        for (int i = 0; i<3; i++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*(10+(kScreenW - 40)/3.f), 0, (kScreenW - 40)/3.f, (kScreenW - 40)/3.f)];
            image.layer.borderWidth = 1.f;
            image.layer.masksToBounds = YES;
            image.layer.cornerRadius = 10.f;
            [self addSubview:image];
            
            switch (i) {
                case 0:
                    _imageOne = image;
                    break;
                case 1:
                    _imageTwo = image;
                    break;
                case 2:
                    _imageThree = image;
                    break;
                default:
                    break;
            }
            
        }
        
    }
    return self;
}

- (void)layoutImageWithPhotoArray:(NSArray *)photoArray indexPath:(NSIndexPath *)indexPath{
    
    if (photoArray.count == 0) {
        _imageOne.image = [UIImage imageNamed:@"默认图片"];
        [self.imageTwo removeFromSuperview];
        [self.imageThree removeFromSuperview];
    }else{
        if (photoArray.count%3 == 0) {
            [_imageOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,photoArray[3*indexPath.row]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
            [_imageTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,photoArray[3*indexPath.row+1]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
            [_imageThree sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,photoArray[3*indexPath.row+2]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
            
        }else if (photoArray.count%3 == 1){
            if (indexPath.row != (photoArray.count/3)) {
                [_imageOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,photoArray[3*indexPath.row]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
                [_imageTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,photoArray[3*indexPath.row+1]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
                [_imageThree sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,photoArray[3*indexPath.row+2]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
            }else{
                [_imageOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,photoArray[3*indexPath.row]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
                [self.imageTwo removeFromSuperview];
                [self.imageThree removeFromSuperview];
                
            }
            
        }
        else{
            if (indexPath.row == photoArray.count/3) {
                [_imageOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,photoArray[3*indexPath.row]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
                [_imageTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,photoArray[3*indexPath.row+1]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
                [self.imageThree removeFromSuperview];
            }else{
                [_imageOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,photoArray[3*indexPath.row]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
                [_imageTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,photoArray[3*indexPath.row+1]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
                [_imageThree sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,photoArray[3*indexPath.row+2]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
            }
            
        }
        
    }
    
}
@end
