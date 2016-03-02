//
//  Publish_AddPhoto_TVC.h
//  Cofactories
//
//  Created by GTF on 16/2/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAssets.h"
@interface Publish_AddPhoto_TVC : UITableViewCell

@property (nonatomic,copy) void(^AddPhotoBlock)(void); 
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic, strong) JKAssets  *asset;
@property (nonatomic,copy) void(^BrowsePhotoBlock)(NSInteger selectedIndex);
@property (nonatomic,copy)void(^PublishBlock)(void);

@end
