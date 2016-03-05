//
//  JKImagePickerTool.h
//  GTFPhotoKit
//
//  Created by GTF on 16/2/29.
//  Copyright © 2016年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface JKImagePickerTool : NSObject
@property (nonatomic,strong)UIViewController<JKImagePickerControllerDelegate> *viewController;
@property (nonatomic,strong)JKImagePickerController *imagePickerController;
@property (nonatomic, strong)NSMutableArray   *assetsArray;
@end
