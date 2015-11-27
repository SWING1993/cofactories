//
//  Order_Common_TVC.m
//  Cofactories
//
//  Created by GTF on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "Order_Common_TVC.h"

@implementation Order_Common_TVC{
    UILabel *_TextFieldTitleLabel;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _TextFieldTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 70, 44)];
        _TextFieldTitleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_TextFieldTitleLabel];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(130, 7, kScreenW - 150, 30)];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_textField];
    }
    
    return self;
}

- (void)returnTextFieldTitleString:(NSString *)titleString indexPath:(NSIndexPath *)indexPath{
    
    NSString *string = [NSString stringWithFormat:@"%@ %@",@"*",titleString];
    
    if (indexPath.row < 3) {
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
        _TextFieldTitleLabel.attributedText = attributedTitle;
        
    }else{
        _TextFieldTitleLabel.text = @"备注";
        _TextFieldTitleLabel.frame = CGRectMake(50, 0, 60, 44);
        _textField.placeholder = @"特殊要求请备注说明";
    }
}


@end
