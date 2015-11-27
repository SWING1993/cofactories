//
//  Order_Common_TVC.h
//  Cofactories
//
//  Created by GTF on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Order_Common_TVC : UITableViewCell

@property (nonatomic,strong)UITextField *textField;

- (void)returnTextFieldTitleString:(NSString *)titleString indexPath:(NSIndexPath *)indexPath;
@end
