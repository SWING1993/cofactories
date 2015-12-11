//
//  MeTextFieldCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MeTextFieldCell.h"

@implementation MeTextFieldCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, 40)];
        self.myLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.myLabel];
        self.myTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.myLabel.frame) + 5, 0, kScreenW - 110, 40)];
        self.myTextField.textAlignment = NSTextAlignmentLeft;
        self.myTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        self.myTextField.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.myTextField];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
