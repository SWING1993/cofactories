//
//  PublishOrder_Three_VC.h
//  Cofactories
//
//  Created by GTF on 16/2/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PublishOrderType){
    PublishOrderTypeFabric, //面料订单
    PublishOrderTypeAccessory, //辅料订单
    PublishOrderTypeMachine //机械设备订单
};

@interface PublishOrder_Three_VC : UIViewController

@property (nonatomic,assign)PublishOrderType orderType;
@end
