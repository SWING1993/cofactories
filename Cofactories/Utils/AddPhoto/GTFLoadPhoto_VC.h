//
//  GTFLoadPhoto_VC.h
//  GTFPhotoKit
//
//  Created by GTF on 16/3/1.
//  Copyright © 2016年 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTFLoadPhoto_VC : UIViewController
@property (nonatomic,strong) NSMutableArray *imagesArray;
@property (nonatomic,assign) NSInteger       selectedIndex;
@property (nonatomic,copy) void(^ReloadBlock)(void); // 导航返回后刷新数据

@end
