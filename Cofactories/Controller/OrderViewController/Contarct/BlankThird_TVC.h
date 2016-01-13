//
//  BlankThird_TVC.h
//  Cofactories
//
//  Created by GTF on 16/1/12.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlankThird_TVC : UITableViewCell
@property(nonatomic,strong)UILabel *dateLB;
- (void)loadDateWithIndexpath:(NSIndexPath *)indexPath titleString:(NSString *)titleString ;
@end
