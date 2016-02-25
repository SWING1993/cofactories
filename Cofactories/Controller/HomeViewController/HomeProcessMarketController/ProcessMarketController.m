//
//  ProcessMarketController.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/3.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ProcessMarketController.h"
#import "ProcessMarketListCell.h"
#import "ZGYTitleView.h"
#import "Business_Factory_VC.h"

static NSString *processCellIdentifier = @"processCell";
@interface ProcessMarketController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    NSArray *photoArray;
    NSArray *titleArray;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ProcessMarketController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"加工配套市场";
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    photoArray = @[@"Process-加工厂", @"Process-锁眼钉扣", @"Process-代裁", @"Process-后整包装", @"Process-砂洗水洗", @"Process-绣花厂", @"Procss-印染厂", @"Process-印花厂", @"Process-其他特种工艺"];
    titleArray = @[@"加工厂", @"锁眼钉扣", @"代裁", @"后整包装", @"砂洗水洗", @"印花厂", @"印染厂", @"绣花厂", @"其他特种工艺"];
    [self creatCollectionView];

    
    UIImageView *allImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 74, 24, 24)];
    allImage.image = [UIImage imageNamed:@"Process-加工配套企业汇总"];
    [self.view addSubview:allImage];
    UILabel *myTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(allImage.frame) + 10, 64, kScreenW - 74, 44)];
    myTitle.text = @"加工配套企业汇总";
    myTitle.font = [UIFont systemFontOfSize:15];
    myTitle.textColor = [UIColor colorWithRed:38.0f/255.0f green:38.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
    [self.view addSubview:myTitle];
    
    
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 108, kScreenW, 10)];
    bigView.backgroundColor = [UIColor colorWithRed:249.0f/255.0f green:249.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    [self.view addSubview:bigView];
    
    for (int i = 0; i < 4; i++) {
        CALayer *line1 = [CALayer layer];
        line1.frame = CGRectMake(0, 64 + 54 + i*(kScreenW/3 + 15*kZGY), kScreenW, 0.5);
        line1.backgroundColor = [UIColor colorWithRed:222.0f/255.0f green:222.0f/255.0f blue:222.0f/255.0f alpha:1.0f].CGColor;
        [self.view.layer addSublayer:line1];
        
    }
    for (int i = 1; i < 3; i++) {
        CALayer *line2 = [CALayer layer];
        line2.frame = CGRectMake(i*kScreenW/3, 64 + 54 , 0.5, 3*(kScreenW/3 + 15*kZGY));
        line2.backgroundColor = [UIColor colorWithRed:222.0f/255.0f green:222.0f/255.0f blue:222.0f/255.0f alpha:1.0f].CGColor;
        [self.view.layer addSublayer:line2];
    }
    CALayer *line3 = [CALayer layer];
    line3.frame = CGRectMake(0, 108, kScreenW, 0.3);
    line3.backgroundColor = [UIColor colorWithRed:222.0f/255.0f green:222.0f/255.0f blue:222.0f/255.0f alpha:1.0f].CGColor;
    [self.view.layer addSublayer:line3];
}
- (void)creatCollectionView {
    //创建CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 54, kScreenW, kScreenH - 54) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ProcessMarketListCell class] forCellWithReuseIdentifier:processCellIdentifier];
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"第 %d 个item", indexPath.row + 1);
    
    NSArray *array = @[@"加工厂",@"锁眼钉扣",@"代裁",@"后整包装",@"砂洗水洗",@"印花厂",@"印染厂",@"绣花厂",@"其他特种工艺"];
    Business_Factory_VC *vc = [[Business_Factory_VC alloc] initWithSubrole:array[indexPath.row] andSelecteDataDictionary:[Tools returenSelectDataDictionaryWithIndex:4]];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProcessMarketListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:processCellIdentifier forIndexPath:indexPath];
    cell.photoView.image = [UIImage imageNamed:photoArray[indexPath.row]];
    cell.processTitle.text = titleArray[indexPath.row];
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenW/3 , kScreenW/3 + 15*kZGY);
}
//分区边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//- (void)back {
//    [self.navigationController popViewControllerAnimated:YES];
//}

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
