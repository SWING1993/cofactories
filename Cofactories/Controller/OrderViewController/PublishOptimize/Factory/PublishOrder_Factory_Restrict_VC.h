//
//  PublishOrder_Factory_VC.h
//  Cofactories
//
//  Created by GTF on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishOrder_Factory_Restrict_VC : UIViewController
@property (nonatomic,strong)UITableView    *tableView;
@property (nonatomic,copy) void(^TypeStringChangeBlock2)(NSString *string);

@end