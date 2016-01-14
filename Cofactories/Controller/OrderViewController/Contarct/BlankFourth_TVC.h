//
//  BlankFourth_TVC.h
//  Cofactories
//
//  Created by GTF on 16/1/12.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BlankFourth_TVC : UITableViewCell
@property (nonatomic,strong)UIButton *selectButtonOne;
@property (nonatomic,strong)UIButton *selectButtonTwo;
- (void)loadDataWithIndexpath:(NSIndexPath *)indexPath titleString:(NSString *)titleString selectArray:(NSArray *)selectArray ;
- (void)buttonClick:(id)sender;

@end
