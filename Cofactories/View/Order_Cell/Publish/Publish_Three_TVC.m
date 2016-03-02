//
//  Publish_Three_TVC.m
//  Cofactories
//
//  Created by GTF on 16/2/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "Publish_Three_TVC.h"

@implementation Publish_Three_TVC{
    UILabel *_titleLB;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLB = [UILabel new];
        _titleLB.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLB];
        
        _cellTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, kScreenW-100, 40)];
        _cellTF.font = [UIFont systemFontOfSize:12];
        _cellTF.textColor = [UIColor lightGrayColor];
        [self addSubview:_cellTF];
        
    }
    return self;
}

- (void)loadDataWithTitleString:(NSString *)titleString
              placeHolderString:(NSString *)placeHolderString
                       indexRow:(NSInteger)indexRow{
    if (indexRow == 3) {
        _titleLB.text = titleString;
        _titleLB.frame = CGRectMake(25, 0, 50, 40);
    }else{
        NSString *string = [NSString stringWithFormat:@"%@ %@",@"*",titleString];
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
        _titleLB.attributedText = attributedTitle;
        _titleLB.frame = CGRectMake(15, 0, 60, 40);
    }
    
    _cellTF.placeholder = placeHolderString;
}

@end
