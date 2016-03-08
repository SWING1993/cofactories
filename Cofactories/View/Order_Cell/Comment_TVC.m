
//
//  Comment_TVC.m
//  Cofactories
//
//  Created by GTF on 15/11/28.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "Comment_TVC.h"

@implementation Comment_TVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.commentLB = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 30)];
        _commentLB.font = [UIFont systemFontOfSize:14];
        _commentLB.text = @"添加备注";
        [self.contentView addSubview:_commentLB];
        
        self.commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 30, kScreenW-40, (kScreenW/2)-40-30-10)];
        self.commentTextView.font = [UIFont systemFontOfSize:12];
        self.commentTextView.layer.masksToBounds = YES;
        self.commentTextView.layer.borderWidth = 0.5;
        self.commentTextView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        self.commentTextView.layer.cornerRadius = 5;
        self.commentTextView.scrollEnabled = NO;
        self.commentTextView.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.commentTextView];
                                                                            
    }
    return self;
}


@end
