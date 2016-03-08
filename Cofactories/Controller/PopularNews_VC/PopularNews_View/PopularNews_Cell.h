//
//  PopularNews_Cell.h
//  Cofactories
//
//  Created by 赵广印 on 16/3/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopularNews_Cell : UITableViewCell

@property (nonatomic, strong) UIImageView *userPhoto;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *newsType;
@property (nonatomic, strong) UILabel *newsTitle;
@property (nonatomic, strong) UILabel *newsDetail;
@property (nonatomic, strong) UIImageView *newsPhoto;
@property (nonatomic, strong) UILabel *readCount;
@property (nonatomic, strong) UILabel *commentCount;


@end
