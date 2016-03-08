//
//  PopularNews_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PopularNews_VC.h"
#import "PopularNews_Cell.h"
#import "PopularNewsTop_Cell.h"
#import "WKFCircularSlidingView.h"
#import "IndexModel.h"
#import "HomeActivity_VC.h"//轮播图点击
#import "PopularNewsType_VC.h"//文章分类

static NSString *topCellIdentifier = @"topCell";
static NSString *newsCellIdentifier = @"newsCell";

@interface PopularNews_VC ()<UISearchBarDelegate, WKFCircularSlidingViewDelegate> {
    UISearchBar     *mySearchBar;
    UIButton        *backgroundView;
}
@property (nonatomic,strong) NSMutableArray *bannerImageArray;
@property (nonatomic,strong) NSMutableArray *bannerArray;
@end

@implementation PopularNews_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatHeaderView];
    [self customSearchBar];
    [self creatBackgroundView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PopularNewsTop_Cell class] forCellReuseIdentifier:topCellIdentifier];
    [self.tableView registerClass:[PopularNews_Cell class] forCellReuseIdentifier:newsCellIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBackgroundViewAction) name:UIKeyboardWillHideNotification object:nil];
}
- (void)creatHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 256 / 640)];
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
            [headerView addSubview:firstView];
            self.tableView.tableHeaderView = headerView;
        }
    }];
}

#pragma mark - 遮盖层
- (void)creatBackgroundView {
    backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundView.frame = CGRectMake(0, 0, kScreenW, 10*kScreenH);
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
    mySearchBar.tintColor = kDeepBlue;
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self controlBackgroundView:0];
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSLog(@"%@",searchBar.text);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PopularNewsTop_Cell *cell = [tableView dequeueReusableCellWithIdentifier:topCellIdentifier forIndexPath:indexPath];
        cell.leftTitle.text = @"LEE全新101系列放出";
        cell.leftDetail.text = @"传承经典，创新再造";
        cell.rightTitle.text = @"印象派大师.莫奈特展";
        cell.rightDetail.text = @"跟着艺术，来跳舞吧";
        [cell.leftButton addTarget:self action:@selector(actionOfTopLeftNews:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightButton addTarget:self action:@selector(actionOfTopRightNews:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        PopularNews_Cell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userPhoto.image = [UIImage imageNamed:@"meinv.jpg"];
        cell.userName.text = @"燕子photo";
        cell.newsType.text = @"设计师";
        cell.newsPhoto.image = [UIImage imageNamed:@"1.jpg"];
        cell.newsTitle.text = @"好戏就要开场，你功课做足了吗？";
        NSString *string = @"我叫我今儿机会也很好斤斤计较尽快解决经济我开开开开开已已已已已已奇偶姐姐看看解决快乐老家临渴掘...";
        
        cell.newsDetail.attributedText = [PopularNews_VC getAttributedStringWithString:string];
        cell.readCount.text = @"153";
        cell.commentCount.text = @"121";
        return cell;
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
        moreTop.frame = CGRectMake(kScreenW - 20*kZGY - 35*kZGY, 0, 35*kZGY, 35*kZGY);
        [moreTop setTitle:@"更多" forState:UIControlStateNormal];
        [moreTop setTitleColor:kDeepBlue forState:UIControlStateNormal];
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
        
        UIButton *moreNews = [UIButton buttonWithType:UIButtonTypeCustom];
        moreNews.frame = CGRectMake(kScreenW - 20*kZGY - 30*kZGY, 2.5*kZGY, 30*kZGY, 30*kZGY);
        [moreNews setImage:[UIImage imageNamed:@"PopularNews-菜单"] forState:UIControlStateNormal];
        [moreNews addTarget:self action:@selector(actionOfMoreNews:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:moreNews];
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
    DLog(@"进入文章详情页");
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
}

- (void)actionOfTopLeftNews:(UIButton *)button {
    DLog(@"置顶左边");
}
- (void)actionOfTopRightNews:(UIButton *)button {
    DLog(@"置顶右边");
}

- (void)actionOfMoreNews:(UIButton *)button {
    DLog(@"更多分类文章");
    PopularNewsType_VC *popularNewsTypeVC = [[PopularNewsType_VC alloc] init];
    [self.navigationController pushViewController:popularNewsTypeVC animated:YES];
}

+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attributedString;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
