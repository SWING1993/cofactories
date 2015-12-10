//
//  WalletHistoryTableViewCell.h
//  Cofactories
//
//  Created by 宋国华 on 15/12/9.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletHistoryTableViewCell : UITableViewCell


@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UILabel * feeLabel;
@property (nonatomic,strong) UILabel * typeLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withRowSize:(CGSize)rowSize ;

@end
