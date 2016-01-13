//
//  Input_OnlyText_Cell.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//
#define kCellIdentifier_Input_OnlyText_Cell_PhoneCode @"Input_OnlyText_Cell_PhoneCode"

#import "Input_OnlyText_Cell.h"


@interface Input_OnlyText_Cell ()

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation Input_OnlyText_Cell
+ (NSString *)randomCellIdentifierOfPhoneCodeType{
    return [NSString stringWithFormat:@"%@_%ld", kCellIdentifier_Input_OnlyText_Cell_PhoneCode, random()];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_textField) {
            _textField = [UITextField new];
            [_textField setFont:[UIFont systemFontOfSize:15]];
            [_textField addTarget:self action:@selector(editDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
            [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
            [_textField addTarget:self action:@selector(editDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
            [self.contentView addSubview:_textField];
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
                make.left.equalTo(self.contentView).offset(18.0);
                make.right.equalTo(self.contentView).offset(-18.0);
                make.centerY.equalTo(self.contentView);
            }];
        }
        

    }
    return self;
}

- (void)prepareForReuse{

    self.textField.secureTextEntry = NO;
    self.textField.userInteractionEnabled = YES;
    self.textField.keyboardType = UIKeyboardTypeDefault;
    
    self.editDidBeginBlock = nil;
    self.textValueChangedBlock = nil;
    self.editDidEndBlock = nil;
}

- (void)setPlaceholder:(NSString *)phStr value:(NSString *)valueStr{
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:phStr? phStr: @"" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    self.textField.text = valueStr;
}

#pragma mark Button

- (void)clearBtnClicked:(id)sender {
    self.textField.text = @"";
    [self textValueChanged:nil];
}


#pragma mark - UIView
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"0xffffff" andAlpha:0.5];
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.contentView).offset(kLoginPaddingLeftWidth);
            make.right.equalTo(self.contentView).offset(-kLoginPaddingLeftWidth);
            make.bottom.equalTo(self.contentView);
        }];
    }
    
    self.backgroundColor =  [UIColor clearColor];
    self.textField.clearButtonMode =UITextFieldViewModeWhileEditing;
    self.textField.textColor = [UIColor blackColor];
    self.lineView.hidden = YES;
}

#pragma mark TextField
- (void)editDidBegin:(id)sender {
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"0xffffff"];
    if (self.editDidBeginBlock) {
        self.editDidBeginBlock(self.textField.text);
    }
}

- (void)editDidEnd:(id)sender {
   self.lineView.backgroundColor = [UIColor colorWithHexString:@"0xffffff" andAlpha:0.5];
    
    if (self.editDidEndBlock) {
        self.editDidEndBlock(self.textField.text);
    }
}

- (void)textValueChanged:(id)sender {
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(self.textField.text);
    }
}
@end
