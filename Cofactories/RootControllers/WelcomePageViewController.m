//
//  WelcomePageViewController.m 
//  Cofactories
//
//  Created by 宋国华 on 15/12/30.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "WelcomePageViewController.h"
#import "RootViewController.h"
#import "EAIntroPage.h"
#import "EAIntroView.h"
/*
 static NSString * const sampleDescription1 = @"全新界面 全新玩法";
 static NSString * const sampleDescription2 = @"在线商城 在线交易";
 static NSString * const sampleDescription3 = @"订单操作 快捷简单";
 static NSString * const sampleDescription4 = @"活动多多 商机多多";
 static NSString * const sampleDescription5 = @"四大专区 应有尽有";
 */

@interface WelcomePageViewController ()<EAIntroDelegate>

@end

@implementation WelcomePageViewController

#pragma mark - EAIntroView delegate

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showIntroWithCrossDissolve];
}

- (void)introDidFinish:(EAIntroView *)introView {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    EAIntroPage *page2 = [EAIntroPage page];
    EAIntroPage *page3 = [EAIntroPage page];
    EAIntroPage *page4 = [EAIntroPage page];
    
    
    if (iphone4x_3_5) {
        DLog(@"4S");
        page1.bgImage = [UIImage imageNamed:@"4S_1"];
        page2.bgImage = [UIImage imageNamed:@"4S_2"];
        page3.bgImage = [UIImage imageNamed:@"4S_3"];
        page4.bgImage = [UIImage imageNamed:@"4S_4"];
    }else {
        page1.bgImage = [UIImage imageNamed:@"01"];
        page2.bgImage = [UIImage imageNamed:@"02"];
        page3.bgImage = [UIImage imageNamed:@"03"];
        page4.bgImage = [UIImage imageNamed:@"04"];
    }
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    
    intro.skipButton.alpha = 0.f;
    intro.skipButton.enabled = NO;
    
    page4.onPageDidAppear = ^{
        intro.skipButton.enabled = YES;
        [UIView animateWithDuration:0.2f animations:^{
            intro.skipButton.alpha = 1.f;
        }];
    };
    
    page4.onPageDidDisappear = ^{
        intro.skipButton.enabled = NO;
        [UIView animateWithDuration:0.3f animations:^{
            intro.skipButton.alpha = 0.f;
        }];
    };
    
    [intro showInView:self.view animateDuration:0.3];
}


@end
