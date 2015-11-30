//
//  ZGYSupplyMarketView.h
//  Cofactories
//
//  Created by 赵广印 on 15/11/30.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupplyMarketButton.h"

@class ZGYSupplyMarketView;

@protocol ZGYSupplyMarketViewDelegate <NSObject>

- (void)supplyMarketView:(ZGYSupplyMarketView *)supplyMarketView supplyMarketButtonTag:(NSInteger)supplyMarketButtonTag;

@end


@interface ZGYSupplyMarketView : UIView

@property (nonatomic, weak) id<ZGYSupplyMarketViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame photoArray:(NSArray *)photoArray titleArray:(NSArray *)titleArray detailTitleArray:(NSArray *)detailTitleArray;
@end
