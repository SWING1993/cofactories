//
//  CYLPlusButtonSubclass.m
//  DWCustomTabBarDemo
//
//  Created by 微博@iOS程序犭袁 (http://weibo.com/luohanchenyilong/) on 15/10/24.
//  Copyright (c) 2015年 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLPlusButtonSubclass.h"
#import "SelectOrder_VC.h"
#import "SearchOrder_Designer_VC.h"
#import "SearchOrder_Factory_VC.h"
#import "MangerOrderVC.h"
#import "OrderList_Supplier_VC.h"
#import "RXRotateButtonOverlayView.h"

@interface CYLPlusButtonSubclass () <RXRotateButtonOverlayViewDelegate>{
    CGFloat _buttonImageHeight;
}
@property(nonatomic,strong)UserModel *userModel;
@property (nonatomic, strong) RXRotateButtonOverlayView* overlayView;
@property (nonatomic, strong) UIViewController* now_VC;

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
    
    _now_VC = [self getCurrentVC];
    [_now_VC.view addSubview:self.overlayView];
    [self.overlayView show];

}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark - RXRotateButtonOverlayViewDelegate
- (void)didSelected:(NSUInteger)index{
    if (index == 0) {
        SelectOrder_VC *vc = [[SelectOrder_VC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [_now_VC presentViewController:nav animated:YES completion:^{
            [_overlayView dismiss];
            }];
 
    }else if (index == 1){
        self.userModel = [[UserModel alloc] getMyProfile];
                switch (self.userModel.UserType) {
                    case UserType_supplier:{
                        OrderList_Supplier_VC *vc = [[OrderList_Supplier_VC alloc] init];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
                        [_now_VC presentViewController:nav animated:YES completion:^{
                            [_overlayView dismiss];
                        }];
        
                    }
                        break;
        
                    case UserType_designer:{
                    SearchOrder_Designer_VC *vc = [[SearchOrder_Designer_VC alloc] init];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
                        [_now_VC presentViewController:nav animated:YES completion:^{
                            [_overlayView dismiss];
                        }];
        
                    }
                        break;
                    case UserType_processing:{
                        SearchOrder_Factory_VC *vc = [[SearchOrder_Factory_VC alloc] init];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
                        [_now_VC presentViewController:nav animated:YES completion:^{
                            [_overlayView dismiss];
                        }];
                    }
                        break;
                        
                    default:
                        kTipAlert(@"该身份接订单功能未开通");
                        break;
                }
                
               

    }else if (index == 2){
        MangerOrderVC *vc = [[MangerOrderVC alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
                [_now_VC presentViewController:nav animated:YES completion:^{
                    [_overlayView dismiss];
                }];

    }
}


- (RXRotateButtonOverlayView *)overlayView{
    if (_overlayView == nil) {
        _overlayView = [[RXRotateButtonOverlayView alloc] init];
        [_overlayView setTitles:@[@"发布订单",@"查找订单",@"管理订单"]];
        [_overlayView setTitleImages:@[@"发布订单",@"查找订单",@"管理订单"]];
        [_overlayView setDelegate:self];
        [_overlayView setFrame:_now_VC.view.bounds];
    }
    return _overlayView;
}




#pragma mark - CYLPlusButtonSubclassing

+ (CGFloat)multiplerInCenterY {
    return  0.3;
}

@end
