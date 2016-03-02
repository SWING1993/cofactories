//
//  GTFLoadPhoto_VC.m
//  GTFPhotoKit
//
//  Created by GTF on 16/3/1.
//  Copyright © 2016年 company. All rights reserved.
//

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "GTFLoadPhoto_VC.h"
#import "JKAssets.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface GTFLoadPhoto_VC ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIButton     *deleteBtn;
@property (nonatomic, strong) JKAssets  *asset;
@end

@implementation GTFLoadPhoto_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%lu",(long)_selectedIndex+1,(unsigned long)_imagesArray.count];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self deleteBtn]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:0 target:self action:@selector(popClick)];
    
    [self setupUIWithImages:_imagesArray selectedIndex:_selectedIndex];
}

- (void)popClick{
    self.ReloadBlock();
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(SCREEN_WIDTH - 40, 20, 20, 20);
        [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除图标"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

- (void)setupUIWithImages:(NSMutableArray *)images selectedIndex:(NSInteger)selectedIndex{
    
    [self scrollView];
    
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*idx, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.userInteractionEnabled = YES;
        
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        
        _asset = images[idx];
        [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                imageView.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            }
        } failureBlock:^(NSError *error) {
            
        }];

        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTouchAction:)];
        [imageView addGestureRecognizer:tapGesture];
        [_scrollView addSubview:imageView];
    }];
    
    _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*selectedIndex, SCREEN_HEIGHT);
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*(images.count), SCREEN_HEIGHT);
    
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)deleteAction{
    
    if (_imagesArray.count > 1) {
        [_imagesArray removeObjectAtIndex:_selectedIndex];
        
        for (UIImageView *imageView in _scrollView.subviews) {
            if (imageView) {
                [imageView removeFromSuperview];
            }
        }
        
        _selectedIndex = (_scrollView.contentOffset.x)/SCREEN_WIDTH;
        
        [self setupUIWithImages:_imagesArray selectedIndex:_selectedIndex];
        
        self.navigationItem.title = [NSString stringWithFormat:@"%ld/%lu",(long)_selectedIndex+1,(unsigned long)_imagesArray.count];

    }else if(_imagesArray.count == 1){
        [_imagesArray removeAllObjects];
        for (UIImageView *imageView in _scrollView.subviews) {
            if (imageView) {
                [imageView removeFromSuperview];
            }
        }
        _selectedIndex = 0;
        self.navigationItem.title = @"";
    }
}

- (void)imageViewTouchAction:(id)sender{
    [self navgationBarShowAndHiddenAnimation];
}

- (void)navgationBarShowAndHiddenAnimation{
    
    NSInteger offsetY = self.navigationController.navigationBar.frame.origin.y < 0 ? 20:-64;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.navigationController.navigationBar.frame = CGRectMake(self.navigationController.navigationBar.frame.origin.x,
                                                                   offsetY,
                                                                   self.navigationController.navigationBar.frame.size.width,
                                                                   self.navigationController.navigationBar.frame.size.height);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _selectedIndex = (_scrollView.contentOffset.x)/SCREEN_WIDTH;
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%lu",(long)_selectedIndex+1,(unsigned long)_imagesArray.count];
}
@end
