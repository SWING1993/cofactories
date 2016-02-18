//
//  MallCommentCell.h
//  Cofactories
//
//  Created by 赵广印 on 16/2/18.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"

@interface MallCommentCell : UITableViewCell

@property (nonatomic, strong) UILabel *commentTitle;
@property (nonatomic, strong) PlaceholderTextView *commentTextView;

@end
