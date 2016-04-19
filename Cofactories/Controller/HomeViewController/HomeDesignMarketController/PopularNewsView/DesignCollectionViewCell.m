//
//  DesignCollectionViewCell.m
//  Cofactories
//
//  Created by 赵广印 on 16/4/18.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "DesignCollectionViewCell.h"
#define kTopHeight 30
#define kMainTitleHeight 22
#define kBlueWidth 24
#define kBlueHeight 6
@implementation DesignCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = kLineGrayCorlor.CGColor;
        self.layer.borderWidth = 0.6;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        self.mainTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, kTopHeight, frame.size.width, kMainTitleHeight)];
        self.mainTitle.textAlignment = NSTextAlignmentCenter;
        self.mainTitle.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.mainTitle];
        
        self.detailTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, kTopHeight + kMainTitleHeight, frame.size.width, kMainTitleHeight)];
        self.detailTitle.textColor = [UIColor lightGrayColor];
        self.detailTitle.font = [UIFont systemFontOfSize:12];
        self.detailTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.detailTitle];
        
        UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2 - kBlueWidth/2, CGRectGetMaxY(self.detailTitle.frame) + 15, kBlueWidth, kBlueHeight)];
        linView.backgroundColor = kMainDeepBlue;
        linView.layer.cornerRadius = kBlueHeight/2;
        linView.clipsToBounds = YES;
        [self addSubview:linView];
        
        
    }
    return self;
}

@end
