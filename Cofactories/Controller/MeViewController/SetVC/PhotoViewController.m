//
//  PhotoViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "HttpClient.h"

#import "JKPhotoBrowser.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "PhotoViewController.h"
#import "TableViewHeaderView.h"

@interface PhotoViewController () <UIImagePickerControllerDelegate, UICollectionViewDelegate,JKImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate> {
    
    UIView*view;
}
@property (nonatomic, strong) JKAssets  *asset;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PhotoViewController

static NSString * const reuseIdentifier = @"collectionViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.isMySelf) {
        UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"上传图片" style:UIBarButtonItemStylePlain target:self action:@selector(uploadBtn)];
        self.navigationItem.rightBarButtonItem = setButton;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 2.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:kScreenBounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];
    
    if (self.photoArray.count == 0) {
        self.collectionView.backgroundView = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) withImage:@"数据暂无" withLabelText:@"暂无照片，点击右上角上传图片吧"];
    }
}

- (void)uploadBtn {
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 10;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
        DLog(@"1");
    }];
}

//下一步
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            self.asset=assets[idx];
            ALAssetsLibrary  * lib = [[ALAssetsLibrary alloc] init];
            [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
                if (asset) {
                    UIImage*image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                    NSData*imageData = UIImageJPEGRepresentation(image, 0.1);
                    UIImage*newImage = [[UIImage alloc]initWithData:imageData];
                    [HttpClient uploadPhotoWithType:@"photo" WithImage:newImage andBlock:^(NSInteger statusCode) {
                        if (statusCode == 200) {
                            if (idx == [assets count]-1) {
                                
                                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"图片正在上传，根据网速不同，请稍后查看。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                                alertView.tag = 201;
                                [alertView show];
                                
//                                kTipAlert(@"图片正在上传，根据网速不同，请稍后查看。");
                            }
                        }
                    }];
                }
            } failureBlock:^(NSError *error) {
                
            }];
            
        }];
    }];
}

//取消
- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        DLog(@"取消");
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 201) {
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/4

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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView*imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,self.photoArray[indexPath.item]]] placeholderImage:[UIImage imageNamed:@"placeholder232"]];
    imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [cell addSubview:imageView];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
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
