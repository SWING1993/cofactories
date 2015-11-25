//
//  WalletSelectView.h
//  Cofactories
//
//  Created by 赵广印 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WalletSelectView;
@protocol  WalletSelectViewDelegate<NSObject>

- (void)selectView:(WalletSelectView *)selectView selectTitle:(NSString *)title;

@end


@interface WalletSelectView : UIView

@property (nonatomic, weak)id<WalletSelectViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)reloadTitles;

@end
