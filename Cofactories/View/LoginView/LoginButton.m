//
//  blueButton.m
//  cofactory-1.1
//
//  Created by 宋国华 on 15/9/22.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "LoginButton.h"

@implementation LoginButton


- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        self.layer.cornerRadius=5.0f;
        self.layer.masksToBounds=YES;

        self.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:171.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}


@end
