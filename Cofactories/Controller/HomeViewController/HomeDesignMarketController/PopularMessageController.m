//
//  PopularMessageController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/28.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "PopularMessageController.h"
#import "WKFCircularSlidingView.h"
#import "PopularNewsCell.h"
#import "ZGYSelectButtonView.h"
#import "PopularCollectionViewCell.h"
#import "ZGYTitleView.h"
#define kSearchFrameLong CGRectMake(50, 30, kScreenW-50, 25)
#define kSearchFrameShort CGRectMake(50, 30, kScreenW-100, 25)

static NSString *newsCellIdentifier = @"newsCell";
static NSString *popularCellIdentifier = @"popularCell";
@interface PopularMessageController ()<UITableViewDataSource, UITableViewDelegate, WKFCircularSlidingViewDelegate, ZGYSelectButtonViewDelegata, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIScrollViewDelegate> {
    NSArray *arr;
    ZGYSelectButtonView *selectBtnView;
    UISearchBar *_searchBar;
    UIView *bigView;
}
@property (nonatomic,strong) NSMutableArray *firstViewImageArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) UITableView *popularTableView;

@end

@implementation PopularMessageController
-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    arr = @[@"男装新潮流", @"服装平台", @"童装设计潮流趋势", @"女装新潮流", ];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:65.0f/255.0f green:145.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.popularTableView.userInteractionEnabled = YES;
    self.popularTableView.backgroundColor = [UIColor whiteColor];
    [self.popularTableView registerClass:[PopularNewsCell class] forCellReuseIdentifier:newsCellIdentifier];
    [self creatSearchBar];
    [self creatHeaderView];
    [self creatFooterView];
    self.popularTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;


}

- (void)creatTableView {
    self.popularTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.popularTableView.dataSource = self;
    self.popularTableView.delegate = self;
//    self.popularTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.popularTableView];
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
    self.searchArray = [NSMutableArray arrayWithCapacity:0];
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

- (void)creatHeaderView {
    //第一个scrollView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 256 / 640 + 5 + 80 + 20 + 25 + 5)];
        headerView.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:252.0f/255.0f blue:253.0f/255.0f alpha:1.0f];
    WKFCircularSlidingView * firstView = [[WKFCircularSlidingView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 256 / 640)];
    firstView.delegate=self;
    self.firstViewImageArray = [NSMutableArray arrayWithArray:arr];
    firstView.imagesArray = self.firstViewImageArray;
    [headerView addSubview:firstView];
    
    //设计师
    UIView *designView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(firstView.frame) + 5, kScreenW - 10, 80)];
    designView.backgroundColor = [UIColor whiteColor];
    designView.layer.borderColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:207.0f/255.0f alpha:1.0f].CGColor;
    designView.layer.borderWidth = 0.3;
    designView.layer.cornerRadius = 3;
    designView.clipsToBounds = YES;
    [headerView addSubview:designView];
    
    UIImageView *designTextPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(20, 22.5, 130, 35)];
    designTextPhoto.image = [UIImage imageNamed:@"Home-Lijo"];
    [designView addSubview:designTextPhoto];
    
    UIImageView *designPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(designView.frame) - 10 - 115, 10, 115, 70)];
    designPhoto.image = [UIImage imageNamed:@"Home-design"];
    designPhoto.userInteractionEnabled = YES;
    [designView addSubview:designPhoto];
    
    
    UIButton *designBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    designBtn.frame = CGRectMake(5, CGRectGetMaxY(firstView.frame) + 5, kScreenW - 10, 80);
    designBtn.backgroundColor = [UIColor clearColor];
    [designBtn addTarget:self action:@selector(actionOfdesign:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:designBtn];
    
    //文章推荐
    
    ZGYTitleView *title1 = [[ZGYTitleView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(designBtn.frame) + 20, kScreenW, 25) Title:@"文章推荐" leftLabelColor:[UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f]];
    [headerView addSubview:title1];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(headerView.frame) - 0.3, kScreenW - 10, 0.3)];
    lineLabel.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:207.0f/255.0f alpha:1.0f];
    [headerView addSubview:lineLabel];
    self.popularTableView.tableHeaderView = headerView;
}
- (void)creatFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 80 + ((kScreenW - 30)/3 + 40)*2 + 30)];
    footerView.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:252.0f/255.0f blue:253.0f/255.0f alpha:1.0f];
    //流行导读
    ZGYTitleView *title2 = [[ZGYTitleView alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 25) Title:@"流行导读" leftLabelColor:[UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f]];
    [footerView addSubview:title2];
    
    //换一批
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(kScreenW - 60, 20, 60, 30);
    [changeBtn setTitle:@"换一批" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [changeBtn addTarget:self action:@selector(actionOfChang:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:changeBtn];
    
    //选择男装、女装、童装、面料
    selectBtnView = [[ZGYSelectButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title2.frame) + 10, kScreenW, 30)];
    selectBtnView.delegate = self;
    [footerView addSubview:selectBtnView];
    [self creatCollectionView];
    [footerView addSubview:self.collectionView];
    
    self.popularTableView.tableFooterView = footerView;
}

- (void)creatCollectionView {
    //创建CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 2.0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectBtnView.frame), kScreenW, ((kScreenW - 30*kZGY)/3 + 40*kZGY)*2 + 30*kZGY) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[PopularCollectionViewCell class] forCellWithReuseIdentifier:popularCellIdentifier];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier forIndexPath:indexPath];
    
    cell.photoView.image = [UIImage imageNamed:@"4.jpg"];
    cell.newstitle.text = @"黑白经典中的时尚男装";
    cell.newsDetail.text = @"型男不容错过的市场款";
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"第 %ld 条资讯", indexPath.row + 1);
}


#pragma mark - 设计师Lijo
- (void)actionOfdesign:(UIButton *)button {
    DLog(@"设计师Lijo");
}
#pragma mark - 换一批
- (void)actionOfChang:(UIButton *)button {
    DLog(@"换一批");
}
#pragma mark -WKFCircularSlidingViewDelegate轮播图
- (void)clickCircularSlidingView:(int)tag{
    DLog(@"点击了第  %d  张图", tag);
}


#pragma mark - ZGYSelectButtonViewDelegata

- (void)selectButtonView:(ZGYSelectButtonView *)selectButtonView selectButtonTag:(NSInteger)selectButtonTag {
    
    switch (selectButtonTag) {
        case 1:{
            DLog(@"男装");
        }
            break;
        case 2:{
            DLog(@"女装");
        }
            break;
        case 3:{
            DLog(@"童装");
        }
            break;
        case 4:{
            DLog(@"面料");
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"第 %d 个新闻", indexPath.row + 1);
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PopularCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:popularCellIdentifier forIndexPath:indexPath];
    cell.photoView.image = [UIImage imageNamed:@"5.jpg"];
    cell.newsTitle.text = @"春夏东京男装发布会最IN";
    cell.likeCountLabel.text = @"2345";
    cell.commentCountLabel.text = @"评论数：999+";
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW - 30*kZGY)/3, (kScreenW - 30*kZGY)/3 + 40*kZGY);
}
//分区边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10*kZGY, 10*kZGY, 10*kZGY, 10*kZGY);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
