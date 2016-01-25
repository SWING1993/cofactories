//
//  MeOrderSelect_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/16.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "MeOrderSelect_VC.h"
#import "MeHistoryBuy_VC.h"
#import "MeHistorySell_VC.h"


@interface MeOrderSelect_VC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, strong) NSMutableArray *viewControllesArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UILabel        *lineLB;

@end

@implementation MeOrderSelect_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"历史订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _viewControllesArray = [@[] mutableCopy];
    _buttonArray = [@[] mutableCopy];
    MeHistoryBuy_VC *vc1 = [[MeHistoryBuy_VC alloc] init];
    MeHistorySell_VC  *vc2 = [[MeHistorySell_VC alloc] init];
    
    [_viewControllesArray addObject:vc1];
    [_viewControllesArray addObject:vc2];
    [self initSelectButon];
    [self initScrollView];

}
- (void)initSelectButon{
    NSArray *array = @[@"购买记录",@"出售记录"];
    for (int i = 0; i<array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kScreenW-200)/3.f+i*(80+(kScreenW-200)/3.f), 64, 100, 44);
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = i+1;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.view addSubview:button];
        
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(0, 64 + 44 - 0.3, kScreenW, 0.3);
        line.backgroundColor = kLineGrayCorlor.CGColor;
        [self.view.layer addSublayer:line];
        
        if (i == 0) {
            [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            _lineLB = [UILabel new];
            _lineLB.frame = CGRectMake(button.frame.origin.x+15, 44 + 64 - 2.5, 70, 2.5);
            _lineLB.backgroundColor = MAIN_COLOR;
            [self.view addSubview:_lineLB];
        }
        
        [_buttonArray addObject:button];
    }

}

- (void)initScrollView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+64, kScreenW, kScreenH-44-64)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(kScreenW*2, kScreenH-44-64);
    
    for (int i = 0; i<_viewControllesArray.count; i++) {
        UIViewController *vc = _viewControllesArray[i];
        vc.view.frame = CGRectMake(i*kScreenW, 0, kScreenW, kScreenH-44-64);
        [_scrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
    
}

- (void)buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    [UIView animateWithDuration:0.2 animations:^{
        _lineLB.frame = CGRectMake(button.frame.origin.x+15, 44 + 64 - 2.5, 70, 2.5);
    }];
    [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    if (button.tag == 1) {
        UIButton *lastButton = (UIButton *)[self.view viewWithTag:2];
        [lastButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if (button.tag == 2){
        UIButton *lastButton = (UIButton *)[self.view viewWithTag:1];
        [lastButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    _scrollView.contentOffset = CGPointMake(kScreenW*(button.tag-1), 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.2 animations:^{
        _lineLB.frame = CGRectMake((kScreenW-200)/3.f+(scrollView.contentOffset.x/scrollView.frame.size.width)*(80+(kScreenW-200)/3.f)+15, 44 + 64 - 2.5, 70, 2.5);
    }];
    
    UIButton *buttonOne = (UIButton *)_buttonArray[0];
    UIButton *buttonTwo = (UIButton *)_buttonArray[1];
    
    if (scrollView.contentOffset.x == 0) {
        [buttonOne setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [buttonTwo setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if (scrollView.contentOffset.x == scrollView.frame.size.width){
        [buttonTwo setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [buttonOne setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
