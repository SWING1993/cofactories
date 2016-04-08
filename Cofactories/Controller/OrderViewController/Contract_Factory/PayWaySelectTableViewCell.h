//
//  PayWaySelectTableViewCell.h
//  Cofactories
//
//  Created by GTF on 16/3/18.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayWayModel.h"
@interface PayWaySelectTableViewCell : UITableViewCell
@property (nonatomic,strong)PayWayModel *payModel;
@property (nonatomic,copy)void(^ReloadBlock)(void);

@end
