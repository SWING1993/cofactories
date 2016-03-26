//
//  HomeViewController.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/6.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeMarketButton.h"
#import "HomeMarketCell.h"
#import "WKFCircularSlidingView.h"

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HomeMarketCellDelegate, WKFCircularSlidingViewDelegate, RCIMUserInfoDataSource, RCIMReceiveMessageDelegate>
@property (nonatomic, strong) UITableView *homeTableView;

@end
