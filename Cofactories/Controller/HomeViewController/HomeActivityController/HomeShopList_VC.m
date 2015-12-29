//
//  HomeShopList_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/29.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "HomeShopList_VC.h"
#import "MaterialShopCell.h"

static NSString *designCellIdentifier = @"designCell";

@interface HomeShopList_VC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *myCollectionView;

@end

@implementation HomeShopList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatCollectionView];

}
- (void)creatCollectionView {
    //创建CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 4;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:layout];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.myCollectionView];
    
    [self.myCollectionView registerClass:[MaterialShopCell class] forCellWithReuseIdentifier:designCellIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MaterialShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:designCellIdentifier forIndexPath:indexPath];
//    SearchShopMarketModel *myModel = self.goodsArray[indexPath.row];
//    //    cell.photoView.image = [UIImage imageNamed:@"4.jpg"];
//    if (myModel.photoArray.count > 0) {
//        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoAPI, myModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
//    } else {
//        cell.photoView.image = [UIImage imageNamed:@"默认图片"];
//    }
//    
//    cell.materialTitle.text = myModel.name;
//    cell.priceLabel.attributedText = [self changeFontAndColorWithString:[NSString stringWithFormat:@"￥ %@", myModel.price]];
//    cell.saleLabel.text = [NSString stringWithFormat:@"已售 %@ 件", myModel.sales];
//    cell.placeLabel.text = myModel.city;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenW/2 - 2 , kScreenW/2 + 100);
}
//分区边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (NSAttributedString *)changeFontAndColorWithString:(NSString *)myString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:myString];
    
    //设置尺寸
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(2, myString.length - 5)]; // 0为起始位置 length是从起始位置开始 设置指定字体尺寸的长度
    
    return attributedString;
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
