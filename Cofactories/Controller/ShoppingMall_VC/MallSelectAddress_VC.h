//
//  SelectAddress_VC.h
//  Cofactories
//
//  Created by 赵广印 on 16/1/26.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MallBuyHistoryModel.h"

@interface MallSelectAddress_VC : UITableViewController

@property (nonatomic, strong) NSMutableDictionary *mallOrderDic;
@property (nonatomic, strong) MallBuyHistoryModel *goodsModel;

@end
