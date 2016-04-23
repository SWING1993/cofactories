//
//  SupplyMarket_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/4/21.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "SupplyMarket_VC.h"
#import "DesignCollectionViewCell.h"
#import "Business_Supplier_VC.h"
#import "FabricShop_VC.h"//面料商城
#import "AccessoryShop_VC.h"//辅料商城
#import "MachineShop_VC.h"//机械设备商城
#define kBlueLineWidth 60


static NSString *supplyMarkrtCellIdentifier = @"supplyMarkrtCell";
static NSString *supplyShopCellIdentifier = @"supplyShopCell";
@interface SupplyMarket_VC ()<UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate> {
    NSMutableArray *btnArray;
    UIView *selectLine;
    UIScrollView *myScrollView;
    UICollectionView *shopCollectionView, *marketCollectionView;
    NSArray *shopMainTitleArray, *shopDetailTitleArray, *marketMainTitleArray, *marketDetailTitleArray;
}

@end

@implementation SupplyMarket_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"供应市场";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatScrollView];
    [self creatSelectView];
}

- (void)creatSelectView {
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 44)];
    bigView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigView];
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, 44 - 0.3, kScreenW, 0.3);
    line.backgroundColor = kLineGrayCorlor.CGColor;
    [bigView.layer addSublayer:line];
    
    CALayer *line1 = [CALayer layer];
    line1.frame = CGRectMake(kScreenW/2, 10, 0.6, 24);
    line1.backgroundColor = kLineGrayCorlor.CGColor;
    [bigView.layer addSublayer:line1];
    
    
    btnArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *supplyArray = @[@"商家汇总", @"商品购买"];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*kScreenW/2, 0, kScreenW/2, 44);
        button.tag = 222 + i;
        [button setTitle:supplyArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f] forState:UIControlStateSelected]
        ;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(actionOfSelect:) forControlEvents:UIControlEventTouchUpInside];
        [bigView addSubview:button];
        [btnArray addObject:button];
        if (button.tag == 222) {
            button.selected = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
    selectLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenW/4 - kBlueLineWidth/2, 44 - 2.5, kBlueLineWidth, 2.5)];
    selectLine.backgroundColor = [UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
    [bigView addSubview:selectLine];
}

- (void)creatScrollView {
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 44, kScreenW, kScreenH - 64 - 44)];
    //    myScrollView.backgroundColor = [UIColor yellowColor];
    myScrollView.contentSize = CGSizeMake(2*kScreenW, kScreenH - 64 - 45);
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.alwaysBounceVertical = NO;
    myScrollView.alwaysBounceHorizontal = NO;
    myScrollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    myScrollView.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:252.0f/255.0f blue:253.0f/255.0f alpha:1.0f];
    
    shopMainTitleArray = @[@"查找面料商家", @"查找辅料商家", @"查找机械设备商家"];
    shopDetailTitleArray = @[@"最全潮面料商家聚集地", @"最全辅料商家聚集地", @"最全机械设备商家聚集地"];
    marketMainTitleArray = @[@"查找面料商品", @"查找辅料商品", @"查找机械设备商品"];
    marketDetailTitleArray = @[@"最全潮面料商品聚集地", @"最全辅料商品聚集地", @"最全机械设备商品聚集地"];
    [self creatShopCollectionView];
    [self creatMarketCollectionView];
}

- (void)creatShopCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 2;
    shopCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 44) collectionViewLayout:layout];
    shopCollectionView.tag = 222;
    shopCollectionView.delegate = self;
    shopCollectionView.dataSource = self;
    shopCollectionView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:shopCollectionView];
    
    [shopCollectionView registerClass:[DesignCollectionViewCell class] forCellWithReuseIdentifier:supplyShopCellIdentifier];
}

- (void)creatMarketCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 2;
    marketCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kScreenW, 0, kScreenW, kScreenH - 44) collectionViewLayout:layout];
    marketCollectionView.tag = 223;
    marketCollectionView.delegate = self;
    marketCollectionView.dataSource = self;
    marketCollectionView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:marketCollectionView];
    
    [marketCollectionView registerClass:[DesignCollectionViewCell class] forCellWithReuseIdentifier:supplyMarkrtCellIdentifier];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 222) {
        DesignCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:supplyShopCellIdentifier forIndexPath:indexPath];
        cell.mainTitle.text = shopMainTitleArray[indexPath.row];
        cell.detailTitle.text = shopDetailTitleArray[indexPath.row];
        return cell;
    } else if (collectionView.tag == 223) {
        DesignCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:supplyMarkrtCellIdentifier forIndexPath:indexPath];
        cell.mainTitle.text = marketMainTitleArray[indexPath.row];
        cell.detailTitle.text = marketDetailTitleArray[indexPath.row];
        return cell;
    } else {
        return nil;
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenW - 30, 110);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 222) {
        switch (indexPath.row) {
            case 0: {
                //面料商家
                Business_Supplier_VC *vc = [[Business_Supplier_VC alloc] initWithSubrole:@"面料商" andSelecteDataDictionary:[Tools returenSelectDataDictionaryWithIndex:3]];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1: {
                //辅料商家
                Business_Supplier_VC *vc = [[Business_Supplier_VC alloc] initWithSubrole:@"辅料商" andSelecteDataDictionary:[Tools returenSelectDataDictionaryWithIndex:3]];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2: {
                //机械设备商家
                Business_Supplier_VC *vc = [[Business_Supplier_VC alloc] initWithSubrole:@"机械设备商" andSelecteDataDictionary:[Tools returenSelectDataDictionaryWithIndex:3]];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    } else if (collectionView.tag == 223) {
        switch (indexPath.row) {
            case 0: {
                //面料商城
                FabricShop_VC *fabricShopVC = [[FabricShop_VC alloc] initWithSubrole:@"" andSelecteDataDictionary:[Tools goodsSelectDataDictionaryWithIndex:1]];
                [self.navigationController pushViewController:fabricShopVC animated:YES];
            }
                break;
            case 1: {
                //辅料商城
                AccessoryShop_VC *accessoryVC = [[AccessoryShop_VC alloc] initWithSubrole:@"辅料商城" andSelecteDataDictionary:[Tools goodsSelectDataDictionaryWithIndex:2]];
                [self.navigationController pushViewController:accessoryVC animated:YES];
            }
                break;
            case 2: {
                //机械设备商城
                MachineShop_VC *machineVC = [[MachineShop_VC alloc] initWithSubrole:@"机械设备" andSelecteDataDictionary:[Tools goodsSelectDataDictionaryWithIndex:3]];
                [self.navigationController pushViewController:machineVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark - 选择切换
- (void)actionOfSelect:(UIButton *)button {
    button.selected = YES;
    for (UIButton *sunbBtn in btnArray) {
        if (sunbBtn != button) {
            sunbBtn.selected = NO;
        }
    }
    
    [myScrollView setContentOffset:CGPointMake((button.tag - 222) * kScreenW, 0) animated:YES];//有动画效果
    
}

#pragma mark - UIScrollViewDelegate

//代理要实现的方法: 切换页面后, 下面的页码控制器也跟着变化
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger btnTag = 0;
    if (scrollView.contentOffset.x == 0) {
        btnTag = 0;
        UIButton *button = [btnArray objectAtIndex:btnTag];
        button.selected = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        for (UIButton *sunbBtn in btnArray) {
            if (sunbBtn != button) {
                sunbBtn.selected = NO;
                sunbBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            }
        }
        
    } else if(scrollView.contentOffset.x == scrollView.frame.size.width){
        btnTag = 1;
        UIButton *button = [btnArray objectAtIndex:btnTag];
        button.selected = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        for (UIButton *sunbBtn in btnArray) {
            if (sunbBtn != button) {
                sunbBtn.selected = NO;
                sunbBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            }
        }
    }
    [UIView animateWithDuration:0.1 animations:^{
        selectLine.frame = CGRectMake(kScreenW/4 - kBlueLineWidth/2 + (scrollView.contentOffset.x/scrollView.frame.size.width)*kScreenW/2, 44- 2.5, kBlueLineWidth, 2.5);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
