//
//  CYLPlusButtonSubclass.m
//  DWCustomTabBarDemo
//
//  Created by 微博@iOS程序犭袁 (http://weibo.com/luohanchenyilong/) on 15/10/24.
//  Copyright (c) 2015年 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLPlusButtonSubclass.h"
#import "CHTumblrMenuView.h"
#import "SelectOrder_VC.h"
#import "SearchOrder_Designer_VC.h"
#import "SearchOrder_Factory_VC.h"
#import "MangerOrderVC.h"
#import "OrderList_Supplier_VC.h"
@interface CYLPlusButtonSubclass () {
    CGFloat _buttonImageHeight;
}
@property(nonatomic,strong)UserModel *userModel;
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
    __unsafe_unretained CHTumblrMenuView *weakView = menuView; //
    [menuView addMenuItemWithTitle:@"发布订单" andIcon:[UIImage imageNamed:@"发布订单"] andSelectedBlock:^{
        NSLog(@"发布订单");
        
        SelectOrder_VC *vc = [[SelectOrder_VC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [viewController presentViewController:nav animated:YES completion:^{
            [weakView dismiss:nil];
        }];
    }];
    [menuView addMenuItemWithTitle:@"查找订单" andIcon:[UIImage imageNamed:@"查找订单"] andSelectedBlock:^{
        NSLog(@"查找订单");
        
        self.userModel = [[UserModel alloc] getMyProfile];
        switch (self.userModel.UserType) {
            case UserType_supplier:
            {
                OrderList_Supplier_VC *vc = [[OrderList_Supplier_VC alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                
                [viewController presentViewController:nav animated:YES completion:^{
                    [weakView dismiss:nil];
                }];
                
            }
                break;
                
            case UserType_designer:
            {
                SearchOrder_Designer_VC *vc = [[SearchOrder_Designer_VC alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                
                [viewController presentViewController:nav animated:YES completion:^{
                    [weakView dismiss:nil];
                }];
                
            }
                break;
            case UserType_processing:
            {
                SearchOrder_Factory_VC *vc = [[SearchOrder_Factory_VC alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                
                [viewController presentViewController:nav animated:YES completion:^{
                    [weakView dismiss:nil];
                }];
            }
                break;
                
            default:
                kTipAlert(@"该身份接订单功能未开通");
                break;
        }
        
       
    }];
    [menuView addMenuItemWithTitle:@"管理订单" andIcon:[UIImage imageNamed:@"管理订单"] andSelectedBlock:^{
        NSLog(@"管理订单");
        MangerOrderVC *vc = [[MangerOrderVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [viewController presentViewController:nav animated:YES completion:^{
            [weakView dismiss:nil];
        }];

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
