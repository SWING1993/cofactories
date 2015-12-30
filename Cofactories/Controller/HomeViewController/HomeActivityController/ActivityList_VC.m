//
//  ActivityList_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/29.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "ActivityList_VC.h"
#import "ActivityListCell.h"
#import "HomeActivity_VC.h"
#import "HomeShopList_VC.h"
static NSString *activityCellIdentifier = @"activityCell";
@interface ActivityList_VC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    NSArray *titleArray;
    NSArray *detailArray;
    NSArray *photoArray;
}
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ActivityList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArray = @[@"织里小李广童裤样品店", @"织里四眼精品屋样品店", @"织里阿丽样品店"];
    detailArray = @[@"主营：男女童样裤版型", @"主营：男女童版型 套装版型", @"主营：男女童样衣版型"];
    photoArray = @[@"公告", @"首页图2", @"首页图3"];
    [self creatCollectionView];

}
- (void)creatCollectionView {
    //创建CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 2;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ActivityListCell class] forCellWithReuseIdentifier:activityCellIdentifier];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ActivityListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:activityCellIdentifier forIndexPath:indexPath];
    cell.activityTitle.text = titleArray[indexPath.row];
    cell.activityDetail.text = detailArray[indexPath.row];
    cell.photoView.image = [UIImage imageNamed:photoArray[indexPath.row]];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeActivity_VC *activityVC = [[HomeActivity_VC alloc] init];
    [self.navigationController pushViewController:activityVC animated:YES];
//    HomeShopList_VC *myShopVC = [[HomeShopList_VC alloc] init];
//    [self.navigationController pushViewController:myShopVC animated:YES];

    
}
#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenW - 20, 65 + (kScreenW - 40)*256/640);
}
//分区边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
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
