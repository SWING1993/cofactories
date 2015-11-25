//
//  AuthenticationCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "AuthenticationCell.h"

@implementation AuthenticationCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 70, 50)];
        self.myLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.myLabel];
        self.myTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.myLabel.frame), 0, kScreenW - 110, 50)];
        self.myTextField.textAlignment = NSTextAlignmentRight;
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
