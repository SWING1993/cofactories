//
//  WalletSelectView.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "WalletSelectView.h"

@implementation WalletSelectView


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        float ww = frame.size.width;
        float hh = frame.size.width;
        UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ww, hh)];
        bigView.tag = 222;
        [self addSubview:bigView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOfTap)];
        [bigView addGestureRecognizer:tap];
        
        
        
        
        
        
        
    }
    return self;
}



- (void)actionOfTap {
    
}













@end
