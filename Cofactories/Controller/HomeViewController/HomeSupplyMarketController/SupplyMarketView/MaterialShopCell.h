//
//  MaterialShopCell.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/4.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchShopMarketModel;

@interface MaterialShopCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *materialTitle;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *saleLabel;
@property (nonatomic, strong) UILabel *placeLabel;

- (void)reloadDataWithSearchShopMarketModel:(SearchShopMarketModel *)searchShopModel;

@end
