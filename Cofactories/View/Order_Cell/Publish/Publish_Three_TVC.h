//
//  Publish_Three_TVC.h
//  Cofactories
//
//  Created by GTF on 16/2/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickCanlendarDelegate <NSObject>
@required
- (void)clickCanlendarButton:(UIButton *)button;
@end

@interface Publish_Three_TVC : UITableViewCell

@property (nonatomic,strong)UITextField *cellTF;
@property (nonatomic,weak)id<ClickCanlendarDelegate> delgate;
@property (nonatomic,assign)BOOL isShowCanlendar;
- (void)loadDataWithTitleString:(NSString *)titleString
              placeHolderString:(NSString *)placeHolderString
                       isLast:(BOOL)isLast;
@end
