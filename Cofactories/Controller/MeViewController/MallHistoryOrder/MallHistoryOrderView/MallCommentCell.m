//
//  MallCommentCell.m
//  Cofactories
//
//  Created by 赵广印 on 16/2/18.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallCommentCell.h"

@implementation MallCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.commentTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenW - 40, 40)];
        self.commentTitle.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.commentTitle];
        
        self.commentTextView = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(20, 40, kScreenW - 40, 100)];
        self.commentTextView.layer.cornerRadius = 3;
        self.commentTextView.clipsToBounds = YES;
        self.commentTextView.layer.borderColor = kLineGrayCorlor.CGColor;
        self.commentTextView.layer.borderWidth = 0.5;
        self.commentTextView.placeholder = @"请输入你的评论内容";
        self.commentTextView.placeholderFont = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.commentTextView];
    }
    return self;
}

@end
