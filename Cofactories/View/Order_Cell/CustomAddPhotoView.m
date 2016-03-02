//
//  CustomAddPhotoView.m
//  Cofactories
//
//  Created by GTF on 16/2/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "CustomAddPhotoView.h"

@implementation CustomAddPhotoView{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 20, 80, 80);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    
}

- (void)buttonClick{
    self.AddPhotoBlock();
}
@end
