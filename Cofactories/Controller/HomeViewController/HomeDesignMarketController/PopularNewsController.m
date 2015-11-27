//
//  PopularNewsController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "PopularNewsController.h"
#import "WKFCircularSlidingView.h"
#import "PopularNewsCell.h"
#import "ZGYSelectButtonView.h"
#import "PopularCollectionViewCell.h"


static NSString *newsCellIdentifier = @"newsCell";
static NSString *popularCellIdentifier = @"popularCell";
@interface PopularNewsController ()<WKFCircularSlidingViewDelegate, ZGYSelectButtonViewDelegata, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    NSArray *arr;
    ZGYSelectButtonView *selectBtnView;
}
@property (nonatomic,strong)NSMutableArray *firstViewImageArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PopularNewsController

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    arr = @[@"男装新潮流", @"服装平台", @"童装设计潮流趋势", @"女装新潮流", ];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:65.0f/255.0f green:145.0f/255.0f blue:228.0f/255.0f alpha:1.0f];

    self.tableView.backgroundColor = [UIColor whiteColor];
    [self creatHeaderView];
    [self creatFooterView];
    [self.tableView registerClass:[PopularNewsCell class] forCellReuseIdentifier:newsCellIdentifier];
}

- (void)creatHeaderView {
    //第一个scrollView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 256 / 640 + 5 + 80 + 20 + 25 + 5)];
//    headerView.backgroundColor = [UIColor redColor];
    WKFCircularSlidingView * firstView = [[WKFCircularSlidingView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 256 / 640)];
    firstView.delegate=self;
    self.firstViewImageArray = [NSMutableArray arrayWithArray:arr];
    firstView.imagesArray = self.firstViewImageArray;
    [headerView addSubview:firstView];
    
    
    //设计师
    UIButton *designBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    designBtn.frame = CGRectMake(5, CGRectGetMaxY(firstView.frame) + 5, kScreenW - 10, 80);
    [designBtn addTarget:self action:@selector(actionOfdesign:) forControlEvents:UIControlEventTouchUpInside];
    designBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    designBtn.layer.borderWidth = 0.3;
    designBtn.layer.cornerRadius = 3;
    designBtn.clipsToBounds = YES;
    [headerView addSubview:designBtn];
    
    UIImageView *designPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(designBtn.frame) - 10 - 120, 5, 120, 70)];
    designPhoto.image = [UIImage imageNamed:@"身份证"];
    designPhoto.userInteractionEnabled = YES;
    [designBtn addSubview:designPhoto];
    
    UILabel *designtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, designBtn.frame.size.width - 150, 20)];
    designtitleLabel.text = @"Lijo";
    designtitleLabel.font = [UIFont boldSystemFontOfSize:16];
    [designBtn addSubview:designtitleLabel];
    
    UILabel *designDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(designtitleLabel.frame), designtitleLabel.frame.size.width, 20)];
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"聚工厂资深时尚设计师"];
    NSRange range1=[[hintString string]rangeOfString:@"资深时尚"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
    designDetailLabel.attributedText = hintString;
    designDetailLabel.font = [UIFont systemFontOfSize:12];
    [designBtn addSubview:designDetailLabel];
    
    
    //文章推荐
    
    UILabel *myLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(designBtn.frame) + 25, 3, 15)];
    myLabel1.backgroundColor = [UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
    [headerView addSubview:myLabel1];
    UILabel *myTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(designBtn.frame) + 20, 80, 25)];
    myTitleLabel1.text = @"文章推荐";
    myTitleLabel1.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:myTitleLabel1];
    self.tableView.tableHeaderView = headerView;
}
- (void)creatFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 80 + ((kScreenW - 30)/3 + 40)*2 + 30)];
    //流行导读
    UILabel *myLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 3, 15)];
    myLabel2.backgroundColor = [UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
    [footerView addSubview:myLabel2];
    UILabel *myTitleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 25)];
    myTitleLabel2.text = @"流行导读";
    myTitleLabel2.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:myTitleLabel2];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(kScreenW - 60, CGRectGetMinX(myTitleLabel2.frame), 60, 30);
    [changeBtn setTitle:@"换一批" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [changeBtn addTarget:self action:@selector(actionOfChang:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:changeBtn];
    
    selectBtnView = [[ZGYSelectButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(myLabel2.frame) + 10, kScreenW, 30)];
    selectBtnView.delegate = self;
    [footerView addSubview:selectBtnView];
    [self creatCollectionView];
    [footerView addSubview:self.collectionView];
    
    
    self.tableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
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

- (void)creatCollectionView {
    //创建CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 2.0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectBtnView.frame), kScreenW, ((kScreenW - 30)/3 + 40)*2 + 30) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[PopularCollectionViewCell class] forCellWithReuseIdentifier:popularCellIdentifier];
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
    
        return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"第 %ld 个新闻", indexPath.row + 1);
}


#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW - 30)/3, (kScreenW - 30)/3 + 40);
}
//分区边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}



@end
