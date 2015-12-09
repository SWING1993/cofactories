//
//  ShoppingCarCell.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/8.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ShoppingCarCell : UITableViewCell

@property (nonatomic, strong) UIImageView *selectView;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *shopCarTitle;
@property (nonatomic, strong) UILabel *shopCarColor;
@property (nonatomic, strong) UILabel *shopCarPrice;
//@property (nonatomic, strong) ShoppingCarNumberView *numberView;
@property (nonatomic, strong) UIButton *cutButton;
@property (nonatomic, strong) UIImageView *cutView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIImageView *addView;
@property (nonatomic, strong) UITextField *myTextfield;



@end
