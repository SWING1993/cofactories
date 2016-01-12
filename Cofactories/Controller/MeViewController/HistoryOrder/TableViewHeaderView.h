//
//  TableViewHeaderView.h
//  Cofactories
//
//  Created by 赵广印 on 16/1/11.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewHeaderView : UIView

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *myLabel;

- (id)initWithFrame:(CGRect)frame withImage:(NSString *)image withLabelText:(NSString *)labelText;

@end
