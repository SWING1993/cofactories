//
//  OrderContract_First_VC.m
//  Cofactories
//
//  Created by GTF on 16/1/12.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "OrderContract_First_VC.h"
#import "FillBlanks_VC.h"

@interface OrderContract_First_VC ()
@property (nonatomic,strong)UIWebView *contractWebview;
@end

@implementation OrderContract_First_VC



- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadWeb];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"填写合同" style:UIBarButtonItemStylePlain target:self action:@selector(signClick)];
}

- (void)loadWeb{
    
    _contractWebview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_contractWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrlString]]];
    [self.view addSubview:_contractWebview];
    
    DLog(@"------%@------",_webUrlString);
}

- (void)signClick{
    FillBlanks_VC *vc = [FillBlanks_VC new];
    vc.orderID = _orderID;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
