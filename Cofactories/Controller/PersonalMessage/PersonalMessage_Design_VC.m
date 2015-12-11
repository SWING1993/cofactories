//
//  PersonalMessage_Design_VC.m
//  Cofactories
//
//  Created by GTF on 15/12/9.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "PersonalMessage_Design_VC.h"
#import "PersonalShop_TVC.h"
#import "PersonalWorks_TVC.h"
#import "DealComment_TVC.h"
#import "MJRefresh.h"
@interface PersonalMessage_Design_VC (){
    NSInteger              _selectedIndex;
    NSMutableArray        *_dataArrayOne;      // 个人店铺
    NSMutableArray        *_dataArrayThree;    // 交易评论
    NSInteger              _refreshCountOne;   // 个人店铺
    NSInteger              _refreshCountThree; // 交易评论
}

@end
static NSString *const reuseIdentifier1 = @"reuseIdentifier1"; // 个人店铺
static NSString *const reuseIdentifier2 = @"reuseIdentifier2"; // 作品集合
static NSString *const reuseIdentifier3 = @"reuseIdentifier3"; // 交易评论

@implementation PersonalMessage_Design_VC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigator_btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClick)];
    self.navigationItem.title = @"个人信息";
    
    _selectedIndex = 1;
    [self creatHeader];
//    [HttpClient publishDesignWithName:@"uwrvchgy" country:@"jp" type:@"female" part:@"suit" price:@"156" marketPrice:@"897" amount:@"134" description:@"asfdojnvdfnehnfoiahreiofoeijh" category:@[@"无色无味"] WithCompletionBlock:^(NSDictionary *dictionary) {
//        
//    }];
    
    _dataArrayOne = [@[] mutableCopy];
    [HttpClient getUserShopWithUserID:_userID page:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        _dataArrayOne = dictionary[@"message"];
        [self.tableView reloadData];
    }];
    
    _dataArrayThree = [@[] mutableCopy];
    [HttpClient getUserCommentWithUserID:_userID page:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        _dataArrayThree = dictionary[@"message"];
        [self.tableView reloadData];
    }];
    
    _refreshCountOne = 1;
    _refreshCountThree = 1;
    [self setupRefresh];
}

#pragma mark - 表头
- (void)creatHeader{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 140)];
    self.tableView.tableHeaderView = headerView;
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
    bgImage.layer.masksToBounds = YES;
    bgImage.layer.cornerRadius = 30;
    [bgImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI,_userID]] placeholderImage:[UIImage imageNamed:@"headBtn.png"]];
    [headerView addSubview:bgImage];
    
    UILabel *nameLB = [[UILabel alloc] init];
    nameLB.font = [UIFont systemFontOfSize:14.f];
    [headerView addSubview:nameLB];
    CGSize size = [Tools getSize:_userModel.name andFontOfSize:14.f];
    nameLB.frame = CGRectMake(90, 25, size.width, size.height);
    nameLB.text = _userModel.name;
    
    UIImageView *typeImage = [[UIImageView alloc] init];
    typeImage.frame = CGRectMake(90+size.width+10, 26, 15, 15);
    [headerView addSubview:typeImage];
    
    if ([_userModel.enterprise isEqualToString:@"非企业用户"]) {
        if ([_userModel.verified isEqualToString:@"非认证用户"]) {
            [typeImage removeFromSuperview];
        }else{
            typeImage.image = [UIImage imageNamed:@"证.png"];
        }
    }else{
        typeImage.image = [UIImage imageNamed:@"企.png"];
    }
    
    UILabel *subroleLB = [[UILabel alloc] init];
    subroleLB.font = [UIFont systemFontOfSize:12.f];
    subroleLB.textColor = [UIColor grayColor];
    subroleLB.layer.masksToBounds = YES;
    subroleLB.layer.borderWidth = 0.5;
    subroleLB.textAlignment = NSTextAlignmentCenter;
    subroleLB.layer.borderColor = [UIColor grayColor].CGColor;
    subroleLB.layer.cornerRadius = 8;
    [headerView addSubview:subroleLB];
    CGSize subroleSize = [Tools getSize:_userModel.subRole andFontOfSize:12.f];
    subroleLB.frame = CGRectMake(90, 25+size.height+5, subroleSize.width+10,subroleSize.height+5);
    subroleLB.text = _userModel.subRole;
    
    NSArray *array = @[_userModel.address,_userModel.descriptions];
    for (int i = 0; i<array.count; i++) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 85+i*25, kScreenW-30, 25)];
        lb.textColor = [UIColor grayColor];
        lb.font = [UIFont systemFontOfSize:12.f];
        lb.text = array[i];
        [headerView addSubview:lb];
    }
}


#pragma mark - 个人店铺、交易评论刷新

- (void)setupRefresh{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"加载中...";
}

- (void)footerRereshing{
    
    if (_selectedIndex == 1) {
        // 刷新店铺
        _refreshCountOne++;
        DLog(@"_refreshCountOne==%d",_refreshCountOne);
        [HttpClient getUserShopWithUserID:_userID page:@(_refreshCountOne) WithCompletionBlock:^(NSDictionary *dictionary){
            
            NSArray *array = dictionary[@"message"];
            
            for (int i=0; i<array.count; i++)
            {
                PersonalShop_Model *model = array[i];
                
                [_dataArrayOne addObject:model];
            }
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
        }];

    }else if (_selectedIndex == 2){
        
        [self.tableView footerEndRefreshing];
        
    }else if (_selectedIndex == 3){
        // 刷新评论
        _refreshCountThree++;
        DLog(@"_refreshCountThree==%d",_refreshCountThree);
        [HttpClient getUserCommentWithUserID:_userID page:@(_refreshCountThree) WithCompletionBlock:^(NSDictionary *dictionary){
            
            NSArray *array = dictionary[@"message"];
            
            for (int i=0; i<array.count; i++)
            {
                DealComment_Model *model = array[i];
                
                [_dataArrayThree addObject:model];
            }
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
        }];
    }
  }

#pragma mark - 表
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //DLog(@">>%d",_dataArrayOne.count);
    
    if (_selectedIndex == 1 ) {
        if (_dataArrayOne.count%2 == 0) {
            return _dataArrayOne.count/2;
        }else{
            return (_dataArrayOne.count/2)+1;
        }
    }else if (_selectedIndex == 2){
        
        if (_userModel.photoArray.count%3 == 0) {
            return _userModel.photoArray.count/3;
        }else{
            return (_userModel.photoArray.count/3)+1;
        }
        
    }else{
        return _dataArrayThree.count;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedIndex == 1 ) {
        PersonalShop_TVC *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[PersonalShop_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier1];
        }
        
        [cell layoutDataWithArray:_dataArrayOne indexPath:indexPath];
        [cell.buttonLeft addTarget:self action:@selector(personalShopClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonRight addTarget:self action:@selector(personalShopClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else if (_selectedIndex == 2){
        PersonalWorks_TVC *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[PersonalWorks_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier2];
        }
        [cell layoutImageWithPhotoArray:_userModel.photoArray indexPath:indexPath];
        return cell;
    }else{
        DealComment_TVC *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[DealComment_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier3];
        }
        DealComment_Model *model = _dataArrayThree[indexPath.row];
        [cell layoutDataWithDealCommentModel:model];
        
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_selectedIndex == 1 ) {
        return (kScreenW-10)/2.f+70;
    }else if (_selectedIndex == 2){
        return (kScreenW - 40)/3.f+10;
    }else if (_selectedIndex == 3){

        return 90;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 41;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    view.backgroundColor = [UIColor whiteColor];
    NSArray *array = @[@"个人店铺",@"个人相册",@"交易评论"];
    for (int i = 0; i<array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*kScreenW/3.f, 0, kScreenW/3.f, 38);
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = i+1;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        if (i == 0) {
            CALayer *_lineLayer = [CALayer layer];
            _lineLayer.frame = CGRectMake((_selectedIndex-1)*kScreenW/3.f, 38, kScreenW/3.f, 2);
            _lineLayer.backgroundColor = MAIN_COLOR.CGColor;
            [view.layer addSublayer:_lineLayer];
        }
        
        if(button.tag == _selectedIndex) {
            button.selected = YES;
        }
        
    }
    return view;
}

#pragma mark - 区头点击

- (void)buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    _selectedIndex = button.tag;
    DLog(@"==%d",_refreshCountOne);

        _refreshCountOne = 1;
        _refreshCountThree = 1;
    [self.tableView reloadData];
    
}

#pragma mark - 个人店铺

- (void)personalShopClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSLog(@"%d",button.tag);
    
    if ([_userModel.role isEqualToString:@"设计者"]) {
        
    }else if ([_userModel.role isEqualToString:@"供应商"]){
        
    }
    
}

#pragma mark - 导航pop
- (void)goBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
