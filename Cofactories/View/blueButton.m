//
//  blueButton.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/9/22.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "blueButton.h"

@implementation blueButton


- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        self.layer.cornerRadius=5.0f;
        self.layer.masksToBounds=YES;
        self.layer.borderColor = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f].CGColor;
        self.layer.borderWidth = 1.0f;
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
    }
    return self;
}


@end
