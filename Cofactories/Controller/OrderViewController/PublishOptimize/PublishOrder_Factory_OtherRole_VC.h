//
//  PublishOrder_Factory_OtherRole_VC.h
//  Cofactories
//
//  Created by GTF on 16/3/2.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PublishFacType) {
    PublishFacTypeDefault, //其他身份发普通加工订单(加工订单)
    PublishFacTypeCommom,  //服装厂发普通加工订单(需求加工厂)
    PublishFacTypeRestrict //服装厂发限制加工订单(需求加工厂)
};

@interface PublishOrder_Factory_OtherRole_VC : UIViewController
@property (nonatomic,assign)PublishFacType pubType;
@property (nonatomic,strong)UITableView *tableView;

@end
