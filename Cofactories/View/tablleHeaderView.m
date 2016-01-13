//
//  tablleHeaderView.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/9/22.
//  Copyright © 2015年 聚工科技. All rights reserved.
//
#import "Login.h"
#import "tablleHeaderView.h"

@implementation tablleHeaderView
UIImageView*logoImage;

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        // 背景色
        [self setBackgroundColor:[UIColor whiteColor]];

        logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-40, 10, 80, 80)];
        logoImage.image= [UIImage imageNamed:@"login_logo"];
        logoImage.layer.cornerRadius = 80/2.0f;
        logoImage.layer.masksToBounds = YES;
        [self addSubview:logoImage];

        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 95, self.frame.size.width, 20)];
        label.text = @"聚工厂";
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}


+ (void)changeImageWithUid:(NSString *)uid {
    if (uid.length<=0) {
        logoImage.image= [UIImage imageNamed:@"login_logo"];
    }else{
        [logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI,uid]] placeholderImage:[UIImage imageNamed:@"login_logo"]];
    }
}


@end
