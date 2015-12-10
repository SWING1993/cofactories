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

@interface PersonalMessage_Design_VC (){
    NSInteger              _selectedIndex;
    
    NSMutableArray        *_dataArrayOne;    // 个人店铺
    NSMutableArray        *_dataArrayThree; // 交易评论

}

@end
static NSString *const reuseIdentifier1 = @"reuseIdentifier1"; // 个人店铺
static NSString *const reuseIdentifier2 = @"reuseIdentifier2"; // 作品集合
static NSString *const reuseIdentifier3 = @"reuseIdentifier3"; // 交易评论

@implementation PersonalMessage_Design_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[PersonalShop_TVC class] forCellReuseIdentifier:reuseIdentifier1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PersonalWorks_TVC class] forCellReuseIdentifier:reuseIdentifier2];
    [self.tableView registerClass:[DealComment_TVC class] forCellReuseIdentifier:reuseIdentifier3];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigator_btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClick)];
    self.navigationItem.title = @"个人信息";
    
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
    
}

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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_selectedIndex == 0 ) {
        if (_dataArrayOne.count%2 == 0) {
            return _dataArrayOne.count/2;
        }else{
            return (_dataArrayOne.count/2)+1;
        }
    }else if (_selectedIndex == 1){
        
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
    if (_selectedIndex == 0 ) {
        PersonalShop_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        [cell layoutDataWithArray:_dataArrayOne indexPath:indexPath];
        [cell.buttonLeft addTarget:self action:@selector(personalShopClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonRight addTarget:self action:@selector(personalShopClick:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
        
    }else if (_selectedIndex == 1){
        PersonalWorks_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2 forIndexPath:indexPath];
        [cell layoutImageWithPhotoArray:_userModel.photoArray indexPath:indexPath];
        return cell;
    }else{
        DealComment_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier3 forIndexPath:indexPath];
        DealComment_Model *model = _dataArrayThree[indexPath.row];
        [cell layoutDataWithDealCommentModel:model];
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_selectedIndex == 0 ) {
        return (kScreenW-10)/2.f+70;
    }else if (_selectedIndex == 1){
        return (kScreenW - 40)/3.f+10;
    }else{
        return 90;
    }
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
        button.tag = i;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        if (i == 0) {
            CALayer *_lineLayer = [CALayer layer];
            _lineLayer.frame = CGRectMake(_selectedIndex*kScreenW/3.f, 38, kScreenW/3.f, 2);
            _lineLayer.backgroundColor = MAIN_COLOR.CGColor;
            [view.layer addSublayer:_lineLayer];
        }
        
        if(i == _selectedIndex) {
            button.selected = YES;
        }
        
    }
    return view;
}

- (void)buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    _selectedIndex = button.tag;
    [self.tableView reloadData];
    
}

#pragma mark - personalShop

- (void)personalShopClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSLog(@"%d",button.tag);
    
    
}

#pragma mark - personalWorks

- (void)goBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
