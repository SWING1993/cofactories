//
//  FactoryOrderDetail_VC.m
//  Cofactories
//
//  Created by GTF on 15/11/30.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "FactoryOrderDetail_VC.h"
#import "OrderPhotoViewController.h"

@interface FactoryOrderDetail_VC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView         *_tableView;
}

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation FactoryOrderDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTableView];
    
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    _tableView.tableHeaderView = headerView;
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame = CGRectMake(15,5, 80, 65);
    imageButton.layer.masksToBounds = YES;
    imageButton.layer.cornerRadius = 5;
    if (_dataModel.photoArray.count > 0) {
        [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,_dataModel.photoArray[0]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
        DLog(@"%@",[NSString stringWithFormat:@"%@%@",PhotoAPI,_dataModel.photoArray[0]]);
    }else{
        [imageButton setBackgroundImage:[UIImage imageNamed:@"placeHolderImage"] forState:UIControlStateNormal];
    }
    [imageButton addTarget:self action:@selector(imageDetailClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:imageButton];
}

- (void)imageDetailClick{
    if (_dataModel.photoArray.count == 0) {
        kTipAlert(@"用户未上传图片");
    }else{
        OrderPhotoViewController *vc = [[OrderPhotoViewController alloc] initWithPhotoArray:_dataModel.photoArray];
        vc.titleString = @"订单图片";
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

@end
