//
//  PopularCollectionViewCell.h
//  Cofactories
//
//  Created by 赵广印 on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopularCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *newsTitle;
@property (nonatomic, strong) UIImageView *likeView;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) UILabel *commentCountLabel;
@end
