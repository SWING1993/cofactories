//
//  PersonalWorks_TVC.h
//  Cofactories
//
//  Created by GTF on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalWorks_TVC : UITableViewCell
@property (nonatomic,strong)UIImageView *imageOne;
@property (nonatomic,strong)UIImageView *imageTwo;
@property (nonatomic,strong)UIImageView *imageThree;
- (void)layoutImageWithPhotoArray:(NSArray *)photoArray indexPath:(NSIndexPath *)indexPath;
@end
