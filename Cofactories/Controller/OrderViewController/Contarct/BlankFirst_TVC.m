//
//  BlankFirst_TVC.m
//  Cofactories
//
//  Created by GTF on 16/1/12.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "BlankFirst_TVC.h"

@implementation BlankFirst_TVC{
    UILabel *_titleLB;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 100, 44)];
        _titleLB.font = [UIFont systemFontOfSize:13];
        [self addSubview:_titleLB];
        
        _dataTF = [[UITextField alloc] initWithFrame:CGRectMake(130, 0, kScreenW-140, 44)];
        _dataTF.textColor = GRAYCOLOR(196);
        _dataTF.font = [UIFont systemFontOfSize:13];
        [self addSubview:_dataTF];
    }
    return self;
}

- (void)loadWithIndexPath:(NSIndexPath *)indexPath titleString:(NSString *)titleString placeHolderString:(NSString *)placeHolderString{
    
    _titleLB.text = titleString;
    _dataTF.placeholder = placeHolderString;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                _dataTF.keyboardType = UIKeyboardTypeDefault;
                break;
            case 1:
                _dataTF.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 2:
                _dataTF.keyboardType = UIKeyboardTypeNumberPad;
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 2:
                _dataTF.keyboardType = UIKeyboardTypeDefault;
                break;
                
            default:
                _dataTF.keyboardType = UIKeyboardTypeNumberPad;
                break;
        }
    }
}


@end
