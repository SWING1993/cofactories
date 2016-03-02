//
//  Publish_Three_TVC.h
//  Cofactories
//
//  Created by GTF on 16/2/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Publish_Three_TVC : UITableViewCell

@property (nonatomic,strong)UITextField *cellTF;
- (void)loadDataWithTitleString:(NSString *)titleString
              placeHolderString:(NSString *)placeHolderString
                       indexRow:(NSInteger)indexRow;
@end
