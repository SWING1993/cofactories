//
//  AllDesignController.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/2.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "AllDesignController.h"
#import "ZGYSelectView.h"
#import "AllDesignCell.h"

#define kSearchFrameLong CGRectMake(50, 30, kScreenW-50, 25)
#define kSearchFrameShort CGRectMake(50, 30, kScreenW-100, 25)

static NSString *designCellIdentifier = @"designCell";
@interface AllDesignController ()<ZGYSelectViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
    ZGYSelectView* selectView;
    UISearchBar *_searchBar;
    UIView *bigView;
}

@property (nonatomic, strong) UITableView *designTableView;

@end

@implementation AllDesignController

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:65.0f/255.0f green:145.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self creatSearchBar];
    [self creatCancleItem];
    [self creatTableView];
    [self creatSelectView];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)creatTableView {
    self.designTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, kScreenW, kScreenH - 45)];
    self.designTableView.dataSource = self;
    self.designTableView.delegate = self;
    [self.view addSubview:self.designTableView];
    self.designTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.designTableView registerClass:[AllDesignCell class] forCellReuseIdentifier:designCellIdentifier];
}
- (void)creatSelectView {
    NSArray *levelArray = @[@"不限等级", @"企业用户", @"认证用户", @"注册用户"];
    NSArray *classArray = @[@"不限种类", @"独立设计师", @"设计工作室"];
    NSArray *placeArray = @[@"不限地区", @"北京", @"上海", @"杭州", @"广州"];
    
    selectView = [[ZGYSelectView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 45) levelArray:levelArray classArray:classArray addressArray:placeArray title:@"不限等级"];
    
    selectView.backgroundColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1];
    [[NSUserDefaults standardUserDefaults] setObject:@"不限类型" forKey:@"ZGYLevelType"];
    selectView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    selectView.layer.borderWidth = 0.5;
    selectView.delegate = self;
    [self.view addSubview:selectView];
}

- (void)creatCancleItem {
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;

}
- (void)creatSearchBar{
    
    self.view.backgroundColor = [UIColor whiteColor];
    _searchBar = [[UISearchBar alloc] initWithFrame:kSearchFrameLong];
    _searchBar.delegate = self;
    [self.navigationController.view addSubview:_searchBar];
    [_searchBar setBackgroundImage:[[UIImage alloc] init] ];
    _searchBar.placeholder = @"搜索文章、图片、作者";
    
}
#pragma mark - UISearchBarDelegate

//点击搜索框改变seachBar的大小，创建取消按钮，添加一层View
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (_searchBar.frame.size.width == kScreenW-50) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleButtonClick)];
        _searchBar.frame = kSearchFrameShort;
        bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        bigView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self.view addSubview:bigView];
    }
}


//点击搜索出结果
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //搜索完移除view改变searchBar的大小
    [searchBar resignFirstResponder];
    [bigView removeFromSuperview];
    _searchBar.frame = kSearchFrameLong;
//    self.searchArray = [NSMutableArray arrayWithCapacity:0];
    //    [HttpClient getInfomationWithKind:[NSString stringWithFormat:@"s=%@", searchBar.text] page:1 andBlock:^(NSDictionary *responseDictionary){
    //        NSArray *jsonArray = responseDictionary[@"responseArray"];
    //        for (NSDictionary *dictionary in jsonArray) {
    //            InformationModel *information = [[InformationModel alloc] initModelWith:dictionary];
    //
    //            [self.searchArray addObject:information];
    //        }
    //        if (self.searchArray.count == 0) {
    //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"搜索结果为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    //            [alertView show];
    //
    //        } else {
    //            [self removeSearchBar];
    //            PMSearchViewController *PMSearchVC = [[PMSearchViewController alloc] init];
    //            //            PMSearchVC.searchArray = [NSMutableArray arrayWithArray:self.searchArray];
    //            PMSearchVC.searchText = searchBar.text;
    //            [self.navigationController pushViewController:PMSearchVC animated:YES];
    //        }
    //    }];
}


//点击键盘之外的View移除View
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_searchBar isExclusiveTouch]) {
        [_searchBar resignFirstResponder];
        [bigView removeFromSuperview];
        _searchBar.frame = kSearchFrameLong;
    }
}

//点击取消收回键盘，移除View，改变seachBar的大小
- (void)cancleButtonClick {
    //收回键盘
    [_searchBar resignFirstResponder];
    [bigView removeFromSuperview];
    _searchBar.frame = kSearchFrameLong;
    
}

//返回时移除searchBar
- (void)back {
    [_searchBar removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
//同时移除searchBar和View（在当前页面操作）
- (void)removeSearchBar {
    [_searchBar removeFromSuperview];
    [bigView removeFromSuperview];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllDesignCell *cell = [tableView dequeueReusableCellWithIdentifier:designCellIdentifier forIndexPath:indexPath];
    cell.designPhoto.image = [UIImage imageNamed:@"4.jpg"];
    cell.levelPhoto.image = [UIImage imageNamed:@"DesignLevel-企业用户"];
    cell.designTitle.text = @"DM服装设计";
    cell.classTitle.text = @"设计工作室";
    cell.addressTitle.text = @"杭州";
    cell.likePhoto.image = [UIImage imageNamed:@"Design-like"];
    cell.likeCount.text = @"1075";
    return cell;
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}



- (void)selectView:(ZGYSelectView*)selectview selectAreaId:(NSString*)areaid andClassifyId:(NSString*)classifyid andRankId:(NSString*)rankId {
    NSLog(@"**************%@ %@ %@", areaid, classifyid, rankId);
    
}
- (void)selectView:(ZGYSelectView*)selectview selectTitle:(NSString*)currTitle {
    NSLog(@"**************%@", currTitle);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
