//
//  AddressTextFieldCell.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/28.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "AddressTextFieldCell.h"

@implementation AddressTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myTextField = [[UITextField alloc] initWithFrame:CGRectMake(10*kZGY, 0, kScreenW - 20, 50*kZGY)];
        self.myTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        self.myTextField.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.myTextField];
        
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(0, 50*kZGY - 0.5, kScreenW, 0.5);
        line.backgroundColor = kLineGrayCorlor.CGColor;
        [self.contentView.layer addSublayer:line];
    }
    
    return self;
}
@end
