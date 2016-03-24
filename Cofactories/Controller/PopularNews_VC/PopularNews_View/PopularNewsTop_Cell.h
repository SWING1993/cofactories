//
//  PopularNewsTop_Cell.h
//  Cofactories
//
//  Created by 赵广印 on 16/3/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopularNewsTop_Cell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImage, *rightImage;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *leftTitle;
@property (nonatomic, strong) UILabel *leftDetail;
@property (nonatomic, strong) UILabel *rightTitle;
@property (nonatomic, strong) UILabel *rightDetail;

- (void)reloadDataWithTopNewsArray:(NSMutableArray *)topNewsArray;
@end
