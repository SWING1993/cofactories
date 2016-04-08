//
//  OrderPhotoViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/8/28.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "OrderPhotoViewController.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface OrderPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,copy)NSArray *photoArray;
@end

@implementation OrderPhotoViewController


- (id)initWithPhotoArray:(NSArray *)photoArray;
{
    if (self = [super init]) {
       
        self.photoArray = photoArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.titleString;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 2.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;


    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:layout];
    
    collectionView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollEnabled = YES;
    
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

}

#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/3

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.photoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView*imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,self.photoArray[indexPath.item]]] placeholderImage:[UIImage imageNamed:@"placeholder232"]];
    imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [cell addSubview:imageView];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DLog(@"11");
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.photoArray count]];
    [self.photoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
       // photo.image = self.collectionImage[idx]; // 图片
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,self.photoArray[idx]]];
        [photos addObject:photo];
    }];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = indexPath.row;
    browser.photos = photos;
    [browser show];

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
