//
//  SearchOrder_Designer_VC.m
//  Cofactories
//
//  Created by GTF on 15/11/30.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "SearchOrder_Designer_VC.h"

@interface SearchOrder_Designer_VC ()<UISearchBarDelegate>

@end

@implementation SearchOrder_Designer_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"查找订单";
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];

}

- (void)customSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入搜索关键字";
    [searchBar setShowsCancelButton:YES];
    self.navigationItem.titleView = searchBar;
    
    for (UIView *view in [[searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
}


- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
