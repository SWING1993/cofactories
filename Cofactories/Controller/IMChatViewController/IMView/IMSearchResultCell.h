//
//  IMSearchResultCell.h
//  Cofactories
//
//  Created by 赵广印 on 16/3/31.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMSearchResultModel;
@interface IMSearchResultCell : UITableViewCell
- (void)layoutSomeDataWithMarketModel:(IMSearchResultModel *)model;

@end
