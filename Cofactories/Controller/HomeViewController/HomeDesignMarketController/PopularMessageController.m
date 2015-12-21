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

#define kSearchFrameLong CGRectMake(50, 30, kScreenW-50, 25)
#define kSearchFrameShort CGRectMake(50, 30, kScreenW-100, 25)

static NSString *newsCellIdentifier = @"newsCell";
static NSString *popularCellIdentifier = @"popularCell";
@interface PopularMessageController ()<UITableViewDataSource, UITableViewDelegate, WKFCircularSlidingViewDelegate, ZGYSelectButtonViewDelegata, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIScrollViewDelegate> {
    NSArray *arr;
    ZGYSelectButtonView *selectBtnView;
    UISearchBar *_searchBar;
    UIView *bigView;
    UIButton *changeBtn;
    MBProgressHUD *hud;
}
@property (nonatomic,strong) NSMutableArray *firstViewImageArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *searchArray;//搜索数组
@property (nonatomic, strong) UITableView *popularTableView;
@property (nonatomic, strong) NSMutableArray *popularTopNewsArray;
@property (nonatomic, strong) NSMutableArray *popularNewsListArray;
@property (nonatomic, assign) NSInteger categoryNum;

@end

@implementation PopularMessageController

- (void)viewWillAppear:(BOOL)animated {
    [self creatSearchBar];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:65.0f/255.0f green:145.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    hud = [Tools createHUD];
    hud.labelText = @"加载中...";
    [self creatTableView];
    arr = @[@"男装新潮流", @"服装平台", @"童装设计潮流趋势", @"女装新潮流", ];
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
        DLog(@"&&&&&&&%@", dictionary[@"responseArray"]);
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
                    [hud hide:YES];
                }
                
            }];
            
        }
        
    }];
    
    
    
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
    DLog(@"chisdjovcjdsopvjopsdj");
    //搜索完移除view改变searchBar的大小
    [searchBar resignFirstResponder];
    [bigView removeFromSuperview];
    _searchBar.frame = kSearchFrameLong;
    [HttpClient searchPopularNewsWithKeyword:_searchBar.text WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        self.searchArray = [NSMutableArray arrayWithCapacity:0];
        if (statusCode == 200) {
            for (NSDictionary *myDic in dictionary[@"responseArray"]) {
                PopularNewsModel *popularNewsModel = [PopularNewsModel getPopularNewsModelWithDictionary:myDic];
                [self.searchArray addObject:popularNewsModel];
            }
            if (self.searchArray.count == 0) {
                kTipAlert(@"搜索结果为空");
            } else {
                [self removeSearchBar];
                PopularNewsList_VC *popularNewsList_VC = [[PopularNewsList_VC alloc] init];
                popularNewsList_VC.popularNewsArray = self.searchArray;
                [self.navigationController pushViewController:popularNewsList_VC animated:YES];
            }
        } else {
            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
            DLog(@"请求失败，statusCode = %ld", statusCode);
        }

    }];
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
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 80 + ((kScreenW - 30)/3 + 60)*2 + 20)];
    footerView.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:252.0f/255.0f blue:253.0f/255.0f alpha:1.0f];
    
    //流行导读
    ZGYTitleView *title2 = [[ZGYTitleView alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 25) Title:@"流行导读" leftLabelColor:[UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f]];
    [footerView addSubview:title2];
    
//    NSTimer *myTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(actionOfTimer) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
    
    
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
    [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kPopularBaseUrl, popularNewsModel.newsImage]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    cell.newstitle.text = popularNewsModel.newsTitle;
    cell.newsDetail.text = popularNewsModel.newsAuthor;
    
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
    [self.navigationController pushViewController:popularVC animated:YES];
    [_searchBar removeFromSuperview];

}


#pragma mark - 设计师Lijo
- (void)actionOfdesign:(UIButton *)button {
    DLog(@"设计师Lijo");
    
    PopularNewsDetails_VC *popularVC = [[PopularNewsDetails_VC alloc] init];
    popularVC.lijoString = @"http://lo.test.mxd.moe/cofactories-3/%E8%AE%BE%E8%AE%A1%E5%B8%88%E4%B8%AA%E4%BA%BA%E8%B5%84%E6%96%99/";
    [self.navigationController pushViewController:popularVC animated:YES];
    [_searchBar removeFromSuperview];
}
#pragma mark - 换一批
- (void)actionOfChang:(UIButton *)button {
    DLog(@"换一批");
    button.userInteractionEnabled = NO;
    [HttpClient getSixPopularNewsListWithCategory:self.categoryNum withBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        self.popularNewsListArray = [NSMutableArray arrayWithCapacity:0];
        if (statusCode == 200) {
            for (NSDictionary *myDic in dictionary[@"responseArray"]) {
                PopularNewsModel *popularNewsModel = [PopularNewsModel getPopularNewsModelWithDictionary:myDic];
                [self.popularNewsListArray addObject:popularNewsModel];
            }
            button.userInteractionEnabled = YES;
            [self.collectionView reloadData];
        } else {
            button.userInteractionEnabled = YES;
        }

    }];
}
#pragma mark -WKFCircularSlidingViewDelegate轮播图
- (void)clickCircularSlidingView:(int)tag{
    DLog(@"点击了第  %d  张图", tag);
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
        } else {
            kTipAlert(@"请求失败");
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
    [_searchBar removeFromSuperview];

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
    [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kPopularBaseUrl, popularNewsModel.newsImage]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    cell.newsTitle.text = popularNewsModel.newsTitle;
    cell.likeCountLabel.text = popularNewsModel.likeNum;
    cell.commentCountLabel.text = [NSString stringWithFormat:@"评论数：%@", popularNewsModel.commentNum];
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


//- (void)actionOfTimer {
//    [changeBtn setTitleColor:[UIColor randomColor] forState:UIControlStateNormal];
//    
//}
//+ (UIColor *) randomColor {
//    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
//    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
