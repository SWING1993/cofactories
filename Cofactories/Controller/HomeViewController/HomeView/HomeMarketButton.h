//
//  HomeMarketButton.h
//  Cofactories
//
//  Created by 赵广印 on 15/11/20.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMarketButton : UIButton

@property (nonatomic, strong) UILabel *marketTextLabel;
@property (nonatomic, strong) UILabel *marketDetailLabel;
@property (nonatomic, strong) UIImageView *marketImage;


- (id)initWithFrame:(CGRect)frame;

@end
