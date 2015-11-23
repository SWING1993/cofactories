//
//  CYLTabBarControllerConfig.m
//  CYLTabBarController
//
//  Created by 微博@iOS程序犭袁 (http://weibo.com/luohanchenyilong/) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLTabBarControllerConfig.h"

//View Controllers
#import "HomeViewController.h"
#import "IMChatViewController.h"
#import "MeViewController.h"
#import "WalletViewController.h"

@interface CYLTabBarControllerConfig ()

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end

@implementation CYLTabBarControllerConfig

/**
 *  lazy load tabBarController
 *
 *  @return CYLTabBarController
 */
- (CYLTabBarController *)tabBarController
{
    if (_tabBarController == nil) {
        HomeViewController *firstViewController = [[HomeViewController alloc] init];
        UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                       initWithRootViewController:firstViewController];
        
        WalletViewController *secondViewController = [[WalletViewController alloc] init];
        UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:secondViewController];
        
        IMChatViewController *thirdViewController = [[IMChatViewController alloc] init];
        UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                       initWithRootViewController:thirdViewController];
        
        MeViewController *fourthViewController = [[MeViewController alloc] init];
        UIViewController *fourthNavigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:fourthViewController];
        
        if ([kBaseUrl isEqualToString:@"http://app.cofactories.com"]) {
            firstViewController.title = @"聚工厂";
        }
        
        else if ([kBaseUrl isEqualToString:@"http://lo.cofactories.com"]) {
            firstViewController.title = @"聚工厂（内网）";
        }
        else if ([kBaseUrl isEqualToString:@"http://test.cofactories.com"]) {
            firstViewController.title = @"聚工厂（测试）";
        }
        
        secondViewController.title = @"钱包";
        thirdViewController.title = @"消息";
        fourthViewController.title = @"我";

        CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
        
        /*
         *
         在`-setViewControllers:`之前设置TabBar的属性，设置TabBarItem的属性，包括 title、Image、selectedImage。
         *
         */
        [self setUpTabBarItemsAttributesForController:tabBarController];
        
        [tabBarController setViewControllers:@[
                                               firstNavigationController,
                                               secondNavigationController,
                                               thirdNavigationController,
                                               fourthNavigationController
                                               ]];
        /**
         *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
         */
        [[self class] customizeTabBarAppearance];
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

/*
 *
 在`-setViewControllers:`之前设置TabBar的属性，设置TabBarItem的属性，包括 title、Image、selectedImage。
 *
 */
- (void)setUpTabBarItemsAttributesForController:(CYLTabBarController *)tabBarController {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"tabHome",
                            CYLTabBarItemSelectedImage : @"tabHomeSelected",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"钱包",
                            CYLTabBarItemImage : @"tabWallet",
                            CYLTabBarItemSelectedImage : @"tabWalletSelected",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"聊天",
                            CYLTabBarItemImage : @"tabmes",
                            CYLTabBarItemSelectedImage : @"tabmesSelected",
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"我",
                            CYLTabBarItemImage : @"tabuser",
                            CYLTabBarItemSelectedImage : @"tabuserSelected"
                            };
    NSArray *tabBarItemsAttributes = @[
                                       dict1,
                                       dict2,
                                       dict3,
                                       dict4
                                       ];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
 */
+ (void)customizeTabBarAppearance {
    
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
//    [[UITabBar appearance] setSelectionIndicatorImage:[self imageFromColor:[UIColor colorWithRed:26/255.0 green:163/255.0 blue:133/255.0 alpha:1] forSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/5.0f, 49) withCornerRadius:0]];
    
    // set the bar background color
    // 设置背景图片
//    UITabBar *tabBarAppearance = [UITabBar appearance];
//    [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background_ios7"]];
}

+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
}

@end
