//
//  WalletViewController.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/18.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *walletTableView;

@end
