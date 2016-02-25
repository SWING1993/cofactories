//
//  MallPayTypeCell.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallPayTypeCell.h"

@implementation MallPayTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        self.photoView.layer.cornerRadius = 6;
        self.photoView.clipsToBounds = YES;
        [self.contentView addSubview:self.photoView];
        self.payTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 15, 15, kScreenW/2, 30)];
        self.payTitle.font = [UIFont systemFontOfSize:14];
        self.payTitle.textColor = GRAYCOLOR(38);
        [self.contentView addSubview:self.payTitle];
        self.paySelect = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 50, 15, 30, 30)];
        [self.contentView addSubview:self.paySelect];
    }
    return self;
}
@end
