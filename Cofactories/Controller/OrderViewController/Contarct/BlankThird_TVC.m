//
//  BlankThird_TVC.m
//  Cofactories
//
//  Created by GTF on 16/1/12.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "BlankThird_TVC.h"

@implementation BlankThird_TVC{
    UILabel *_titleLB;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 100, 44)];
        _titleLB.font = [UIFont systemFontOfSize:13];
        [self addSubview:_titleLB];
        
        _dateLB = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, kScreenW-140, 44)];
        _dateLB.textColor = GRAYCOLOR(196);
        _dateLB.font = [UIFont systemFontOfSize:13];
        [self addSubview:_dateLB];
    }
    return self;
}

- (void)loadDateWithIndexpath:(NSIndexPath *)indexPath titleString:(NSString *)titleString{
    _titleLB.text = titleString;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
