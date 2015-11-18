//
//  CYLPlusButtonSubclass.m
//  DWCustomTabBarDemo
//
//  Created by 微博@iOS程序犭袁 (http://weibo.com/luohanchenyilong/) on 15/10/24.
//  Copyright (c) 2015年 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLPlusButtonSubclass.h"
#import "CHTumblrMenuView.h"

@interface CYLPlusButtonSubclass () {
    CGFloat _buttonImageHeight;
}
@end
@implementation CYLPlusButtonSubclass

#pragma mark -
#pragma mark - Life Cycle

+(void)load {
    [super registerSubclass];
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    
    return self;
}


//上下结构的 button
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 控件大小,间距大小
    CGFloat const imageViewEdge   = self.bounds.size.width * 0.6;
    CGFloat const centerOfView    = self.bounds.size.width * 0.5;
    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
    CGFloat const verticalMarginT = self.bounds.size.height - labelLineHeight - imageViewEdge;
    CGFloat const verticalMargin  = verticalMarginT / 2;
    
    // imageView 和 titleLabel 中心的 Y 值
    CGFloat const centerOfImageView  = verticalMargin + imageViewEdge * 0.5;
    CGFloat const centerOfTitleLabel = imageViewEdge  + verticalMargin * 2 + labelLineHeight * 0.5 + 5;
    
    //imageView position 位置
    self.imageView.bounds = CGRectMake(0, 0, imageViewEdge, imageViewEdge);
    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);
    
    //title position 位置
    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
}

#pragma mark -
#pragma mark - Public Methods
/*
 *
 Create a custom UIButton with title and add it to the center of our tab bar
 *
 */
//+ (instancetype)plusButton{
//    
//    CYLPlusButtonSubclass *button = [[CYLPlusButtonSubclass alloc] init];
//    
//    [button setImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
//    [button setTitle:@"发布" forState:UIControlStateNormal];
//    
//    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
//    [button sizeToFit];
//    
//    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
//    
//    return button;
//}

/*
 *
 Create a custom UIButton without title and add it to the center of our tab bar
 *
 */
+ (instancetype)plusButton
{

    UIImage *buttonImage = [UIImage imageNamed:@"post_normal"];
    UIImage *highlightImage = [UIImage imageNamed:@"post_normal"];

    CYLPlusButtonSubclass* button = [CYLPlusButtonSubclass buttonWithType:UIButtonTypeCustom];

    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

#pragma mark -
#pragma mark - Event Response

- (void)clickPublish {
      [self showMenu];
}

- (void)showMenu{
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UIViewController *viewController = tabBarController.selectedViewController;
    

    CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
    [menuView addMenuItemWithTitle:@"供应面料" andIcon:[UIImage imageNamed:@"面辅料_供应面料"] andSelectedBlock:^{
        NSLog(@"供应面料");
    }];
    [menuView addMenuItemWithTitle:@"供应辅料" andIcon:[UIImage imageNamed:@"面辅料_供应辅料"] andSelectedBlock:^{
        NSLog(@"供应辅料");
    }];
    [menuView addMenuItemWithTitle:@"供应坯布" andIcon:[UIImage imageNamed:@"面辅料_供应胚布"] andSelectedBlock:^{
        NSLog(@"供应坯布");
        
    }];
    
    [menuView show];
}



#pragma mark - CYLPlusButtonSubclassing

//+ (NSUInteger)indexOfPlusButtonInTabBar {
//    return 3;
//}

+ (CGFloat)multiplerInCenterY {
    return  0.3;
}

@end
