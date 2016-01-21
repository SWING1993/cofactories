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
#import "PopularNewsModel.h"
#import "PopularNewsDetails_VC.h"
#import "PopularNewsList_VC.h"
#import "IndexModel.h"
#import "HomeActivity_VC.h"


#define kSearchFrameLong CGRectMake(50, 30, kScreenW-50, 25)
#define kSearchFrameShort CGRectMake(50, 30, kScreenW-100, 25)

static NSString *newsCellIdentifier = @"newsCell";
static NSString *popularCellIdentifier = @"popularCell";
@interface PopularMessageController ()<UITableViewDataSource, UITableViewDelegate, WKFCircularSlidingViewDelegate, ZGYSelectButtonViewDelegata, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIScrollViewDelegate> {
    NSArray *arr;
    ZGYSelectButtonView *selectBtnView;
    UISearchBar *_searchBar;
    UIButton *changeBtn;
    MBProgressHUD *hud;
    UIButton *backgroundView;
}
@property (nonatomic,strong) NSMutableArray *firstViewImageArray;
@property (nonatomic,strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *searchArray;//搜索数组
@property (nonatomic, strong) UITableView *popularTableView;
@property (nonatomic, strong) NSMutableArray *popularTopNewsArray;
@property (nonatomic, strong) NSMutableArray *popularNewsListArray;
@property (nonatomic, assign) NSInteger categoryNum;

@end

@implementation PopularMessageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self creatSearchBar];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:65.0f/255.0f green:145.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    [_searchBar removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatTableView];
    arr = @[@"PopularNews-男装", @"PopularNews-女装", @"PopularNews-童装", @"PopularNews-面辅料"];
    self.categoryNum = 0;
    self.popularTableView.userInteractionEnabled = YES;
    self.popularTableView.backgroundColor = [UIColor whiteColor];
    [self.popularTableView registerClass:[PopularNewsCell class] forCellReuseIdentifier:newsCellIdentifier];
    [self creatHeaderView];
    [self creatFooterView];
    self.popularTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;

    [HttpClient getPopularNewsWithBlock:^(NSDictionary *dictionary) {
//        DLog(@"&&&&&&&%@", dictionary[@"responseArray"]);
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        self.popularTopNewsArray = [NSMutableArray arrayWithCapacity:0];
        if (statusCode == 200) {
            for (NSDictionary *myDic in dictionary[@"responseArray"]) {
                PopularNewsModel *popularNewsModel = [PopularNewsModel getPopularNewsModelWithDictionary:myDic];
                [self.popularTopNewsArray addObject:popularNewsModel];
            }
            [HttpClient getSixPopularNewsListWithCategory:0 withBlock:^(NSDictionary *dictionary) {
                NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
                self.popularNewsListArray = [NSMutableArray arrayWithCapacity:0];
                if (statusCode == 200) {
                    for (NSDictionary *myDic in dictionary[@"responseArray"]) {
                        PopularNewsModel *popularNewsModel = [PopularNewsModel getPopularNewsModelWithDictionary:myDic];
                        [self.popularNewsListArray addObject:popularNewsModel];
                    }
                    [hud hide:YES];
                    [self.collectionView reloadData];
                    [self.popularTableView reloadData];
                } else {
                    DLog(@"男装请求失败，statusCode = %ld", (long)statusCode);
                    [hud hide:YES];
                }
                
            }];
            
        } else {
            DLog(@"文章推荐请求失败，statusCode = %ld", (long)statusCode);
            [hud hide:YES];
        }
        
    }];
    
    hud = [Tools createHUDWithView:self.view];
    hud.labelText = @"加载中...";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBackgroundViewAction) name:UIKeyboardWillHideNotification object:nil];
    [self creatBackgroundView];
}

- (void)creatTableView {
    self.popularTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.popularTableView.dataSource = self;
    self.popularTableView.delegate = self;
//    self.popularTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.popularTableView];
}
#pragma mark - 遮盖层
- (void)creatBackgroundView {
    backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundView.frame = CGRectMake(0, 64, kScreenW, kScreenH);
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
            [_searchBar resignFirstResponder];
            [_searchBar setShowsCancelButton:NO animated:YES];
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)creatSearchBar{
    
    self.view.backgroundColor = [UIColor whiteColor];
    _searchBar = [[UISearchBar alloc] initWithFrame:kSearchFrameLong];
    _searchBar.delegate = self;
    _searchBar.tintColor = kDeepBlue;
    _searchBar.placeholder = @"搜索文章、图片、作者";
    [_searchBar setShowsCancelButton:NO];
    [self.navigationController.view addSubview:_searchBar];
    [_searchBar setBackgroundImage:[[UIImage alloc] init] ];
    
    
    for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }

}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    //把backgroundView提到最前面，遮挡筛选器
    [self.view bringSubviewToFront:backgroundView];
    [self controlBackgroundView:0.3];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self controlBackgroundView:0];
    [self.view endEditing:YES];
}

//点击搜索出结果
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //搜索完移除view改变searchBar的大小
    [HttpClient searchPopularNewsWithKeyword:_searchBar.text WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        self.searchArray = [NSMutableArray arrayWithCapacity:0];
        if (statusCode == 200) {
            for (NSDictionary *myDic in dictionary[@"responseArray"]) {
                PopularNewsModel *popularNewsModel = [PopularNewsModel getPopularNewsModelWithDictionary:myDic];
                [self.searchArray addObject:popularNewsModel];
            }
            [self controlBackgroundView:0];
            if (self.searchArray.count == 0) {
                kTipAlert(@"搜索结果为空");
            } else {
                PopularNewsList_VC *popularNewsList_VC = [[PopularNewsList_VC alloc] init];
                popularNewsList_VC.popularNewsArray = self.searchArray;
                [self.navigationController pushViewController:popularNewsList_VC animated:YES];
            }
        } else {
            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
            DLog(@"请求失败，statusCode = %ld", (long)statusCode);
        }

    }];
}


- (void)creatHeaderView {
    //第一个scrollView
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 256 / 640 + 5 + 80 + 20 + 25 + 5)];
    headerView.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:252.0f/255.0f blue:253.0f/255.0f alpha:1.0f];
    
    //设计师
    UIView *designView = [[UIView alloc] initWithFrame:CGRectMake(5, kScreenW * 256 / 640 + 5, kScreenW - 10, 80)];
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
    designBtn.frame = CGRectMake(5, kScreenW * 256 / 640 + 5, kScreenW - 10, 80);
    designBtn.backgroundColor = [UIColor clearColor];
    [designBtn addTarget:self action:@selector(actionOfdesign:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:designBtn];
    
    //文章推荐
    
    ZGYTitleView *title1 = [[ZGYTitleView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(designBtn.frame) + 20, kScreenW, 25) Title:@"文章推荐" leftLabelColor:[UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f]];
    [headerView addSubview:title1];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(headerView.frame) - 0.3, kScreenW - 10, 0.3)];
    lineLabel.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:207.0f/255.0f alpha:1.0f];
    [headerView addSubview:lineLabel];
    
    [HttpClient getConfigWithType:@"news" WithBlock:^(NSDictionary *responseDictionary) {
        int statusCode = [responseDictionary[@"statusCode"] intValue];
        DLog(@"statusCode = %d", statusCode);
        if (statusCode == 200) {
            NSArray *jsonArray = (NSArray *)responseDictionary[@"responseArray"];
            self.firstViewImageArray = [NSMutableArray arrayWithCapacity:0];
            self.bannerArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dictionary in jsonArray) {
                IndexModel *bannerModel = [IndexModel getIndexModelWithDictionary:dictionary];
                [self.bannerArray addObject:bannerModel];
                [self.firstViewImageArray addObject:bannerModel.img];
            }
            WKFCircularSlidingView * firstView = [[WKFCircularSlidingView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 256 / 640)isNetwork:YES];
            firstView.delegate=self;
            firstView.imagesArray = self.firstViewImageArray;
            [headerView addSubview:firstView];
            self.popularTableView.tableHeaderView = headerView;
        }
    }];
    
}
- (void)creatFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 80 + ((kScreenW - 30)/3 + 60)*2 + 20)];
    footerView.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:252.0f/255.0f blue:253.0f/255.0f alpha:1.0f];
    
    //流行导读
    ZGYTitleView *title2 = [[ZGYTitleView alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 25) Title:@"流行导读" leftLabelColor:[UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f]];
    [footerView addSubview:title2];

    //换一批
    changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(kScreenW - 65, 20, 65, 30);
    [changeBtn setTitle:@"换一批" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
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
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectBtnView.frame), kScreenW, ((kScreenW - 30*kZGY)/3 + 60*kZGY)*2 + 30*kZGY) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[PopularCollectionViewCell class] forCellWithReuseIdentifier:popularCellIdentifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.popularTopNewsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PopularNewsModel *popularNewsModel = self.popularTopNewsArray[indexPath.row];
    [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kPopularBaseUrl, popularNewsModel.newsImage]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    cell.newstitle.text = popularNewsModel.newsTitle;
    cell.newsDetail.text = popularNewsModel.discriptions;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"第 %ld 条资讯", indexPath.row + 1);
    PopularNewsModel *popularNewsModel = self.popularTopNewsArray[indexPath.row];
    PopularNewsDetails_VC *popularVC = [[PopularNewsDetails_VC alloc] init];
    popularVC.newsID = popularNewsModel.newsID;
    popularVC.popularNewsModel = popularNewsModel;
    [self.navigationController pushViewController:popularVC animated:YES];
}

#pragma mark - 设计师Lijo
- (void)actionOfdesign:(UIButton *)button {
    PopularNewsDetails_VC *popularVC = [[PopularNewsDetails_VC alloc] init];
    popularVC.lijoString = [NSString stringWithFormat:@"%@%@", kH5BaseUrl, @"/info/about-designer/"];
    [self.navigationController pushViewController:popularVC animated:YES];
}
#pragma mark - 换一批
- (void)actionOfChang:(UIButton *)button {
    DLog(@"换一批");
    [HttpClient getSixPopularNewsListWithCategory:self.categoryNum withBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        self.popularNewsListArray = [NSMutableArray arrayWithCapacity:0];
        if (statusCode == 200) {
            for (NSDictionary *myDic in dictionary[@"responseArray"]) {
                PopularNewsModel *popularNewsModel = [PopularNewsModel getPopularNewsModelWithDictionary:myDic];
                [self.popularNewsListArray addObject:popularNewsModel];
            }
            [self.collectionView reloadData];
        } else {
        }
    }];
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

#pragma mark - ZGYSelectButtonViewDelegata
- (void)selectButtonView:(ZGYSelectButtonView *)selectButtonView selectButtonTag:(NSInteger)selectButtonTag {
    DLog(@"^^^^^^^^^%ld", selectButtonTag);
    self.categoryNum = selectButtonTag - 1;
    [HttpClient getSixPopularNewsListWithCategory:self.categoryNum withBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        self.popularNewsListArray = [NSMutableArray arrayWithCapacity:0];
        if (statusCode == 200) {
            for (NSDictionary *myDic in dictionary[@"responseArray"]) {
                PopularNewsModel *popularNewsModel = [PopularNewsModel getPopularNewsModelWithDictionary:myDic];
                [self.popularNewsListArray addObject:popularNewsModel];
            }
            [self.collectionView reloadData];
            DLog(@"请求成功，statusCode = %ld", (long)statusCode);
        } else {
            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
            DLog(@"请求失败，statusCode = %ld", (long)statusCode);
//            kTipAlert(@"网络不太顺畅哦~");
        }
    }];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PopularNewsModel *popularNewsModel = self.popularNewsListArray[indexPath.row];
    PopularNewsDetails_VC *popularVC = [[PopularNewsDetails_VC alloc] init];
    popularVC.newsID = popularNewsModel.newsID;
    popularVC.popularNewsModel = popularNewsModel;
    [self.navigationController pushViewController:popularVC animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //xy方向缩放的初始值为0.5
    cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
    //设置动画时间为0.25秒,xy方向缩放的最终值为1
    [UIView animateWithDuration:0.5 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.popularNewsListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PopularCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:popularCellIdentifier forIndexPath:indexPath];
    PopularNewsModel *popularNewsModel = self.popularNewsListArray[indexPath.row];
    [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kPopularBaseUrl, popularNewsModel.newsImage]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    cell.newsTitle.text = popularNewsModel.newsTitle;
    cell.likeCountLabel.text = popularNewsModel.likeNum;
    cell.commentCountLabel.text = [NSString stringWithFormat:@"阅读数：%@", popularNewsModel.clickNum];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW - 30*kZGY)/3, (kScreenW - 30*kZGY)/3 + 60*kZGY);
}
//分区边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10*kZGY, 10*kZGY, 10*kZGY, 10*kZGY);
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
