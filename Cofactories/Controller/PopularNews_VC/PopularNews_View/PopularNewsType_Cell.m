//
//  PopularNewsType_Cell.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/8.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PopularNewsType_Cell.h"

@implementation PopularNewsType_Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        self.photoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.photoView];
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 10, 15, 100, 20)];
        self.typeLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:self.typeLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.self.typeLabel.frame), CGRectGetMaxY(self.typeLabel.frame), 200, 30)];
        self.detailLabel.font = [UIFont systemFontOfSize:10];
        self.detailLabel.textColor = GRAYCOLOR(102);
        self.detailLabel.numberOfLines = 2;
        [self addSubview:self.detailLabel];
        
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
