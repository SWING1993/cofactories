//
//  PopularNewsHome_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/24.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PopularNewsHome_VC.h"
#import "PopularNews_Cell.h"
#import "PopularNewsTop_Cell.h"
#import "WKFCircularSlidingView.h"
#import "IndexModel.h"
#import "HomeActivity_VC.h"//轮播图点击
#import "PopularNewsType_VC.h"//文章分类
#import "PopularNewsModel.h"
#import "MJRefresh.h"
#import "PopularNews_Detail_VC.h"
#import "SearchNews_List_VC.h"

static NSString *topCellIdentifier = @"topCell";
static NSString *newsCellIdentifier = @"newsCell";
@interface PopularNewsHome_VC ()<UITableViewDataSource, UITableViewDelegate, WKFCircularSlidingViewDelegate, UISearchBarDelegate> {
    UISearchBar     *mySearchBar;
    UIButton        *backgroundView;
    NSInteger       page;
}
@property (nonatomic, strong) NSMutableArray *bannerImageArray;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic, strong) NSMutableArray *topNewsArray;
@property (nonatomic, strong) NSMutableArray *searchArray;//搜索数组
@property (nonatomic, strong) UITableView *popularTableView;

@end

@implementation PopularNewsHome_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBackgroundViewAction) name:UIKeyboardWillHideNotification object:nil];
    [self creatTableHeaderView];
    [self getConfig];
    [self customSearchBar];
    [self creatBackgroundView];
    [self getTopNews];
    page = 1;
    [self netWork];
    [self setupRefresh];
}
- (void)creatTableView {
    self.popularTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.popularTableView.dataSource = self;
    self.popularTableView.delegate = self;
    self.popularTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.popularTableView];
    [self.popularTableView registerClass:[PopularNewsTop_Cell class] forCellReuseIdentifier:topCellIdentifier];
    [self.popularTableView registerClass:[PopularNews_Cell class] forCellReuseIdentifier:newsCellIdentifier];
}
- (void)getTopNews {
    [HttpClient getPopularNewsTopWithPage:@1 withBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        if (statusCode == 200) {
            self.topNewsArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *newsDic in dictionary[@"data"]) {
                PopularNewsModel *newsModel = [PopularNewsModel getPopularNewsModelWithDictionary:newsDic];
                [self.topNewsArray addObject:newsModel];
            }
            [self.popularTableView reloadData];
        }
    }];
    
}

- (void)setupRefresh{
    [self.popularTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.popularTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.popularTableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.popularTableView.footerRefreshingText = @"加载中...";
}
- (void)footerRereshing{
    page++;
    [self netWork];
    [self.popularTableView footerEndRefreshing];
}
- (void)netWork {
    [HttpClient getPopularNewsListWithCategory:nil page:@(page) withBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        if (statusCode == 200) {
            if (page == 1) {
                self.newsArray = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *newsDic in dictionary[@"data"]) {
                    PopularNewsModel *newsModel = [PopularNewsModel getPopularNewsModelWithDictionary:newsDic];
                    [self.newsArray addObject:newsModel];
                }
            } else if (page > 1) {
                for (NSDictionary *newsDic in dictionary[@"data"]) {
                    PopularNewsModel *newsModel = [PopularNewsModel getPopularNewsModelWithDictionary:newsDic];
                    [self.newsArray addObject:newsModel];
                }
            }
            [self.popularTableView reloadData];
        }
    }];
}

- (void)creatTableHeaderView {
    UIImageView *placeHolderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 256 / 640)];
    placeHolderView.image = [UIImage imageNamed:@"bannerPlaceHolder"];
    self.popularTableView.tableHeaderView = placeHolderView;
}

- (void)getConfig {
    
    [HttpClient getConfigWithType:@"news" WithBlock:^(NSDictionary *responseDictionary) {
        int statusCode = [responseDictionary[@"statusCode"] intValue];
        DLog(@"statusCode = %d", statusCode);
        if (statusCode == 200) {
            NSArray *jsonArray = (NSArray *)responseDictionary[@"responseArray"];
            self.bannerImageArray = [NSMutableArray arrayWithCapacity:0];
            self.bannerArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dictionary in jsonArray) {
                IndexModel *bannerModel = [IndexModel getIndexModelWithDictionary:dictionary];
                [self.bannerArray addObject:bannerModel];
                [self.bannerImageArray addObject:bannerModel.img];
            }
            WKFCircularSlidingView * firstView = [[WKFCircularSlidingView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 256 / 640)isNetwork:YES];
            firstView.delegate=self;
            firstView.imagesArray = self.bannerImageArray;
            self.popularTableView.tableHeaderView = firstView;
        }
    }];
}

#pragma mark - 遮盖层
- (void)creatBackgroundView {
    backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.0f;
    [backgroundView addTarget:self action:@selector(clickBackgroundViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backgroundView];
}

- (void) clickBackgroundViewAction {
    [self controlBackgroundView:0];
}

- (void)controlBackgroundView:(float)alphaValue {
    [UIView animateWithDuration:0.2 animations:^{
        backgroundView.alpha = alphaValue;
        if (alphaValue <= 0) {
            [mySearchBar resignFirstResponder];
            [mySearchBar setShowsCancelButton:NO animated:YES];
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 搜索框
- (void)customSearchBar{
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"搜索文章、图片、作者";
    mySearchBar.tintColor = kMainDeepBlue;
    [mySearchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"SearchBarBackgroundColor"] forState:UIControlStateNormal];
    mySearchBar.backgroundColor = [UIColor clearColor];
    [mySearchBar setShowsCancelButton:NO];
    self.navigationItem.titleView = mySearchBar;
    
    for (UIView *view in [[mySearchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    //把backgroundView提到最前面，遮挡筛选器
    [self.view bringSubviewToFront:backgroundView];
    [self controlBackgroundView:0.3];
}
//点击取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self controlBackgroundView:0];
    [self.view endEditing:YES];
}
//点击搜索出结果
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //搜索完移除view改变searchBar的大小
    [HttpClient searchPopularNewsWithKeyword:mySearchBar.text WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        self.searchArray = [NSMutableArray arrayWithCapacity:0];
        if (statusCode == 200) {
            for (NSDictionary *myDic in dictionary[@"responseArray"]) {
                PopularNewsModel *popularNewsModel = [PopularNewsModel getPopularNewsModelWithDictionary:myDic];
                [self.searchArray addObject:popularNewsModel];
            }
            [self controlBackgroundView:0];
            if (self.searchArray.count == 0) {
                double delayInSeconds = 0.5f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                   kTipAlert(@"搜索结果为空");
                });
                
            } else {
                SearchNews_List_VC *searchNews_List_VC = [[SearchNews_List_VC alloc] init];
                searchNews_List_VC.title = @"搜索结果";
                searchNews_List_VC.searchNewsArray = self.searchArray;
                [self.navigationController pushViewController:searchNews_List_VC animated:YES];
            }
        } else {
            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
            DLog(@"请求失败，statusCode = %ld", (long)statusCode);
        }
        
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.topNewsArray.count == 0) {
            return 0;
        } else {
            return 1;
        }
    } else {
        return self.newsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PopularNewsTop_Cell *cell = [tableView dequeueReusableCellWithIdentifier:topCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell reloadDataWithTopNewsArray:self.topNewsArray];
        [cell.leftButton addTarget:self action:@selector(actionOfTopLeftNews:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightButton addTarget:self action:@selector(actionOfTopRightNews:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.section == 1) {
        PopularNews_Cell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        PopularNewsModel *popularNewsModel = self.newsArray[indexPath.row];
        [cell reloadDataWithPopularNewsModel:popularNewsModel];
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 35*kZGY)];
        headerView.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
        UILabel *topTitle = [[UILabel alloc] initWithFrame:CGRectMake(20*kZGY, 0, 100*kZGY, 35*kZGY)];
        topTitle.text = @"置顶话题";
        topTitle.textColor = [UIColor colorWithRed:142/255.0 green:140/255.0 blue:146/255.0 alpha:1.0];
        topTitle.font = [UIFont systemFontOfSize:13*kZGY];
        [headerView addSubview:topTitle];
        UIButton *moreTop = [UIButton buttonWithType:UIButtonTypeCustom];
        moreTop.frame = CGRectMake(kScreenW - 75*kZGY, 0, 75*kZGY, 35*kZGY);
        [moreTop setTitle:@"更多" forState:UIControlStateNormal];
        [moreTop setTitleColor:kMainDeepBlue forState:UIControlStateNormal];
        moreTop.titleLabel.font = [UIFont systemFontOfSize:13*kZGY];
        [moreTop addTarget:self action:@selector(actionOfMoreTop:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:moreTop];
        return headerView;
    } else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 35*kZGY)];
        headerView.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
        UILabel *topTitle = [[UILabel alloc] initWithFrame:CGRectMake(20*kZGY, 0, 100*kZGY, 35*kZGY)];
        topTitle.text = @"今日话题";
        topTitle.textColor = [UIColor colorWithRed:142/255.0 green:140/255.0 blue:146/255.0 alpha:1.0];
        topTitle.font = [UIFont systemFontOfSize:13*kZGY];
        [headerView addSubview:topTitle];
        
        UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 75*kZGY, 0, 75*kZGY, 35*kZGY)];
        moreImage.contentMode = UIViewContentModeScaleAspectFit;
        moreImage.userInteractionEnabled = YES;
        moreImage.image = [UIImage imageNamed:@"PopularNews-菜单"];
        UITapGestureRecognizer *clickTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOfMoreNews:)];
        [moreImage addGestureRecognizer:clickTag];
        [headerView addSubview:moreImage];
        return headerView;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70*kZGY;
    } else {
        return 135*kZGY;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35*kZGY;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        DLog(@"进入文章详情页");
        PopularNewsModel *newsModel = self.newsArray[indexPath.row];
        PopularNews_Detail_VC *detailVC = [[PopularNews_Detail_VC alloc] init];
        detailVC.popularNewsModel = newsModel;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark -WKFCircularSlidingViewDelegate轮播图
- (void)clickCircularSlidingView:(int)tag{
    DLog(@"点击了第  %d  张图", tag);
    HomeActivity_VC *activityVC = [[HomeActivity_VC alloc] init];
    IndexModel *bannerModel = self.bannerArray[tag - 1];
    if ([bannerModel.action isEqualToString:@"url"]) {
        activityVC.urlString = bannerModel.url;
        activityVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activityVC animated:YES];
    } else {
        DLog(@"无链接，点不进去");
    }
}

#pragma mark - Action
- (void)actionOfMoreTop:(UIButton *)button {
    DLog(@"更多置顶");
    SearchNews_List_VC *searchNews_List_VC = [[SearchNews_List_VC alloc] init];
    searchNews_List_VC.title = @"置顶文章";
    searchNews_List_VC.searchNewsArray = self.topNewsArray;
    [self.navigationController pushViewController:searchNews_List_VC animated:YES];
}

- (void)actionOfTopLeftNews:(UIButton *)button {
    DLog(@"置顶左边");
    PopularNewsModel *newsModel = self.topNewsArray[0];
    PopularNews_Detail_VC *detailVC = [[PopularNews_Detail_VC alloc] init];
    detailVC.popularNewsModel = newsModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)actionOfTopRightNews:(UIButton *)button {
    DLog(@"置顶右边");
    PopularNewsModel *newsModel = self.topNewsArray[1];
    PopularNews_Detail_VC *detailVC = [[PopularNews_Detail_VC alloc] init];
    detailVC.popularNewsModel = newsModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)actionOfMoreNews:(UITapGestureRecognizer *)click {
    DLog(@"更多分类文章");
    PopularNewsType_VC *popularNewsTypeVC = [[PopularNewsType_VC alloc] init];
    [self.navigationController pushViewController:popularNewsTypeVC animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
