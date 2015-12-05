//
//  CompletionOrder_TVC.h
//  Cofactories
//
//  Created by GTF on 15/12/5.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletionOrder_TVC : UITableViewCell
- (void)layoutWithDataModel:(ProcessingAndComplitonOrderModel *)dataModel userModel:(UserModel *)userModel;
@property (nonatomic,assign)BOOL isMark;  //  是否评分
@end
