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
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(15*kZGY, 15*kZGY, 50*kZGY, 50*kZGY)];
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoView.clipsToBounds = YES;
        [self addSubview:self.photoView];
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 10*kZGY, 15*kZGY, 100*kZGY, 20*kZGY)];
        self.typeLabel.font = [UIFont boldSystemFontOfSize:15*kZGY];
        [self addSubview:self.typeLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.self.typeLabel.frame), CGRectGetMaxY(self.typeLabel.frame), 250*kZGY, 30*kZGY)];
        self.detailLabel.font = [UIFont systemFontOfSize:11*kZGY];
        self.detailLabel.textColor = GRAYCOLOR(102);
        self.detailLabel.numberOfLines = 2;
        [self addSubview:self.detailLabel];
        
    }
    return self;
}

@end
