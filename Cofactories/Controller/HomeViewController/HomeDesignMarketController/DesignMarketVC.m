//
//  DesignMarketVC.m
//  Cofactories
//
//  Created by 赵广印 on 16/4/18.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "DesignMarketVC.h"
#import "DesignCollectionViewCell.h"
#import "AllDesignController.h"
#import "DesignShop_VC.h"
#import "KoreaDesignMallVC.h"

static NSString *designCellIdentifier = @"designCell";
@interface DesignMarketVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    NSArray *mainTitleArray, *detailTitleArray;
    
}

@end

@implementation DesignMarketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设计市场";
    mainTitleArray = @[@"设计师集中营", @"自由市场", @"韩版代购"];
    detailTitleArray = @[@"最全潮流设计师聚集地", @"最全国内版型聚集地", @"最全韩国版型聚集地"];
    [self creatCollectionView];
}

- (void)creatCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 2;
    UICollectionView *designCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:layout];
    designCollectionView.delegate = self;
    designCollectionView.dataSource = self;
    designCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:designCollectionView];
    
    [designCollectionView registerClass:[DesignCollectionViewCell class] forCellWithReuseIdentifier:designCellIdentifier];
}

#pragma mark - UICollectionViewDataSource 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DesignCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:designCellIdentifier forIndexPath:indexPath];
    cell.mainTitle.text = mainTitleArray[indexPath.row];
    cell.detailTitle.text = detailTitleArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            AllDesignController *allDesignVC = [[AllDesignController alloc] initWithSelecteDataDictionary:[Tools returenSelectDataDictionaryWithIndex:1]];
            [self.navigationController pushViewController:allDesignVC animated:YES];
        }
            break;
        case 1: {
            DesignShop_VC *designShopVC = [[DesignShop_VC alloc] initWithSubrole:@"设计者" andSelecteDataDictionary:[Tools goodsSelectDataDictionaryWithIndex:4]];
            [self.navigationController pushViewController:designShopVC animated:YES];
        }
            break;
        case 2: {
            KoreaDesignMallVC *designVC = [[KoreaDesignMallVC alloc] init];
            [self.navigationController pushViewController:designVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenW - 30, 110);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
