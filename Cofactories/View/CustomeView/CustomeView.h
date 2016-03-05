//
//  CustomeView.h
//  ChuangKe
//
//  Created by GTF on 15/11/28.
//  Copyright © 2015年 GUY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomeView : UIView
@property(nonatomic,assign)NSInteger moneyAmount;
@property(nonatomic,assign)NSInteger amount;
@property(nonatomic,copy)void(^MoneyBlock)(NSInteger integer);
@end
