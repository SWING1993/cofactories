//
//  JKImagePickerTool.m
//  GTFPhotoKit
//
//  Created by GTF on 16/2/29.
//  Copyright © 2016年 company. All rights reserved.
//

#import "JKImagePickerTool.h"

@implementation JKImagePickerTool

- (instancetype)init{
    if (self = [super init]) {
        _imagePickerController = [[JKImagePickerController alloc] init];
        _imagePickerController.showsCancelButton = YES;
        _imagePickerController.allowsMultipleSelection = YES;
        _imagePickerController.minimumNumberOfSelection = 1;
        _imagePickerController.selectedAssetArray = nil;
    }
        return self;
}

- (void)setAssetsArray:(NSMutableArray *)assetsArray{
    _assetsArray = assetsArray;
    _imagePickerController.maximumNumberOfSelection = 9 - _assetsArray.count;
}

- (void)setViewController:(UIViewController<JKImagePickerControllerDelegate> *)viewController{
        _viewController = viewController;
        _imagePickerController.delegate = _viewController;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_imagePickerController];
         NSLog(@"%lu,,,,,,%lu",(unsigned long)_imagePickerController.maximumNumberOfSelection,(unsigned long)_assetsArray.count);
        [_viewController presentViewController:navigationController animated:YES completion:NULL];
}
    
    @end
