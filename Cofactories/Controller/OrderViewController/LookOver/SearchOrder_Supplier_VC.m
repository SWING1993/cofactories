//
//  SearchOrder_VC.m
//  Cofactories
//
//  Created by GTF on 15/11/28.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "SearchOrder_Supplier_VC.h"

@interface SearchOrder_Supplier_VC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView     *_tableView;
    CALayer         *_lineLayer;
    NSMutableArray  *_buttonArray;
}

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";

@implementation SearchOrder_Supplier_VC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [HttpClient searchSupplierOrderWithKeyword:@"" type:@"" WithCompletionBlock:^(NSDictionary *dictionary) {
        DLog(@"%@",dictionary);
        [_tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    _buttonArray = [@[] mutableCopy];
    [self customSearchBar];
    [self initTableView];
}

#pragma mark - 关键字搜索
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

#pragma mark - 表

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    view.backgroundColor = [UIColor grayColor];
    
    NSArray *array = @[@"不限",@"面料",@"辅料",@"机械设备"];
    for (int i = 0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(kScreenW/4.f), 0, kScreenW/4.f, 42);
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = i+1;
        [button addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        if (i==0) {
            [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            [_buttonArray addObject:button];
        }
    }
    
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        _lineLayer.backgroundColor = MAIN_COLOR.CGColor;
        _lineLayer.frame = CGRectMake(0, 42, kScreenW/4.f, 2);
        [view.layer addSublayer:_lineLayer];
    }
    
    return view;
}

- (void)typeClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    UIButton *lastButton = [_buttonArray firstObject];
    [lastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [_buttonArray removeAllObjects];
    [_buttonArray addObject:button];
    
    [UIView animateWithDuration:1.f animations:^{
        _lineLayer.frame = CGRectMake(button.frame.origin.x, 42, kScreenW/4.f, 2);
    }];
    
    switch (button.tag) {
        case 1:
        {
            [HttpClient searchSupplierOrderWithKeyword:@"" type:@"" WithCompletionBlock:^(NSDictionary *dictionary) {
                DLog(@"%@",dictionary);
                [_tableView reloadData];
            }];
        }
            break;
            
        case 2:
        {
            [HttpClient searchSupplierOrderWithKeyword:@"" type:@"fabric" WithCompletionBlock:^(NSDictionary *dictionary) {
                DLog(@"%@",dictionary);
                [_tableView reloadData];
            }];
        }
            break;
            
        case 3:
        {
            [HttpClient searchSupplierOrderWithKeyword:@"" type:@"accessory" WithCompletionBlock:^(NSDictionary *dictionary) {
                DLog(@"%@",dictionary);
                [_tableView reloadData];
            }];
        }
            break;
            
        case 4:
        {
            [HttpClient searchSupplierOrderWithKeyword:@"" type:@"machine" WithCompletionBlock:^(NSDictionary *dictionary) {
                DLog(@"%@",dictionary);
                [_tableView reloadData];
            }];
        }
            
            break;
        default:
            break;
    }
}

- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
