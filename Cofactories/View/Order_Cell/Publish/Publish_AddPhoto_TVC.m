//
//  Publish_AddPhoto_TVC.m
//  Cofactories
//
//  Created by GTF on 16/2/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "Publish_AddPhoto_TVC.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define kPhotoWidth  ([UIScreen mainScreen].bounds.size.width - 50)/4.f

@implementation Publish_AddPhoto_TVC{
    UIButton *_addButton;
    UIButton *_publishButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupAddButton];

        [self addPublishBtn];
        
    }
    return self;
}

- (void)setupAddButton{
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addButton];
}

- (void)setImageArray:(NSMutableArray *)imageArray{
    _imageArray = imageArray;
    
    if (_imageArray.count > 0) {
        [self addImageView];
    }else{
        for (UIImageView *image in self.subviews) {
            if (image) {
                [image removeFromSuperview];
            }
        }
        
        [self setupAddButton];
        _addButton.frame = CGRectMake(10+(kPhotoWidth+10)*(_imageArray.count%4), 15+(kPhotoWidth+15)*(_imageArray.count/4), kPhotoWidth, kPhotoWidth);
        
        [self addPublishBtn];
        _publishButton.frame = CGRectMake(15, _addButton.frame.origin.y + kPhotoWidth + 15, kScreenW - 30, 35);
    }
    
//    DLog(@"888888888888");
//    
//    _publishButton.frame = CGRectMake(15, _addButton.frame.origin.y + kPhotoWidth + 15, kScreenW - 30, 35);
//    
//    DLog(@">>>%@",NSStringFromCGRect(_publishButton.frame));
}

- (void)addImageView{
    
    for (UIImageView *image in self.subviews) {
        if (image) {
            [image removeFromSuperview];
        }
    }
    
    [self setupAddButton];
    _addButton.frame = CGRectMake(10+(kPhotoWidth+10)*(_imageArray.count%4), 15+(kPhotoWidth+15)*(_imageArray.count/4), kPhotoWidth, kPhotoWidth);
    
    [self addPublishBtn];
    _publishButton.frame = CGRectMake(15, _addButton.frame.origin.y + kPhotoWidth + 15, kScreenW - 30, 35);

    for (int i = 0; i<_imageArray.count; i++) {
        
        UIButton *photo = [[UIButton alloc] initWithFrame:CGRectMake(10+(kPhotoWidth+10)*(i%4), 15+(kPhotoWidth+15)*(i/4), kPhotoWidth, kPhotoWidth)];
        photo.tag = i;
        [photo addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchUpInside];
        
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        
        _asset = _imageArray[i];
        [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                [photo setImage:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] forState:UIControlStateNormal];
            }
        } failureBlock:^(NSError *error) {
            
        }];
        [self addSubview:photo];
    }
}

- (void)buttonClick{
    self.AddPhotoBlock();
}

- (void)photoAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    self.BrowsePhotoBlock(button.tag);
}


- (void)addPublishBtn{
    _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_publishButton setTitle:@"发布订单" forState:UIControlStateNormal];
    _publishButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_publishButton setBackgroundColor:MAIN_COLOR];
    _publishButton.layer.masksToBounds = YES;
    _publishButton.layer.cornerRadius = 4;
    [_publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_publishButton];
    
}

- (void)publishClick{
    self.PublishBlock();
}

@end
