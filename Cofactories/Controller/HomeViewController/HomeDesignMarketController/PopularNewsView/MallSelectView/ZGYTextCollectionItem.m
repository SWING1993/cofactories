//
//  ZGYTextCollectionCell.m
//  MallOfCofactories
//
//  Created by 赵广印 on 16/4/16.
//  Copyright © 2016年 聚工科技. All rights reserved.
//

#import "ZGYTextCollectionItem.h"

@implementation ZGYTextCollectionItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.myTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.myTextLabel.font = [UIFont systemFontOfSize:14];
        self.myTextLabel.textAlignment = NSTextAlignmentCenter;
        self.myTextLabel.textColor = [UIColor darkGrayColor];
        self.myTextLabel.layer.cornerRadius = 5;
        self.myTextLabel.clipsToBounds = YES;
        self.myTextLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.myTextLabel.layer.borderWidth = 0.5;
        [self addSubview:self.myTextLabel];
    }
    return self;
}

@end
