//
//  BlankFirst_TVC.h
//  Cofactories
//
//  Created by GTF on 16/1/12.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlankFirst_TVC : UITableViewCell
@property (nonatomic,strong)UITextField *dataTF; // 传递 @"品名",@"总数量(件)",@"总价(元)"
- (void)loadWithIndexPath:(NSIndexPath *)indexPath titleString:(NSString *)titleString placeHolderString:(NSString *)placeHolderString;
@end
