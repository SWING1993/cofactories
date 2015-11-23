//
//  HomeMarketCell.h
//  Cofactories
//
//  Created by 赵广印 on 15/11/21.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeMarketButton.h"
@class HomeMarketCell;
@protocol  HomeMarketCellDelegate<NSObject>

- (void)homeMarketCell:(HomeMarketCell *)homeMarket marketButtonTag:(NSInteger)marketButtonTag;

@end




@interface HomeMarketCell : UITableViewCell

//@property (nonatomic, strong) HomeMarketButton *marketButton1, *marketButton2, *marketButton3, *marketButton4;

@property (nonatomic, weak) id<HomeMarketCellDelegate>delegate;

@end
