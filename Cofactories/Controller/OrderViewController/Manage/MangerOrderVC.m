//
//  MangerOrderVC.m
//  Cofactories
//
//  Created by GTF on 15/11/28.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MangerOrderVC.h"
#import "ProgressingOrder_VC.h"
#import "CompletionOrder_VC.h"

@interface MangerOrderVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, strong) NSMutableArray *viewControllesArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UILabel        *lineLB;


@end

@implementation MangerOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"管理订单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _viewControllesArray = [@[] mutableCopy];
    _buttonArray = [@[] mutableCopy];
    ProgressingOrder_VC *vc1 = [ProgressingOrder_VC new];
    CompletionOrder_VC  *vc2 = [CompletionOrder_VC new];
    [_viewControllesArray addObject:vc1];
    [_viewControllesArray addObject:vc2];
    
    [self initSelectButon];
    [self initScrollView];

}


- (void)initSelectButon{
    NSArray *array = @[@"进行中订单",@"已完成订单"];
    for (int i = 0; i<array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kScreenW-200)/3.f+i*(80+(kScreenW-200)/3.f), 64, 100, 35);
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = i+1;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.view addSubview:button];
        
        if (i == 0) {
            [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            _lineLB = [UILabel new];
            _lineLB.frame = CGRectMake(button.frame.origin.x+15, 37+64, 70, 2);
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
        _lineLB.frame = CGRectMake(button.frame.origin.x+15, 37+64, 70, 2);
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
    DLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    [UIView animateWithDuration:0.2 animations:^{
        _lineLB.frame = CGRectMake((kScreenW-200)/3.f+(scrollView.contentOffset.x/scrollView.frame.size.width)*(80+(kScreenW-200)/3.f)+15, 37+64, 70, 2);
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

- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
