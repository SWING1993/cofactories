//
//  Publish_AddPhoto_TVC.h
//  Cofactories
//
//  Created by GTF on 16/2/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomAddPhotoView;

@interface Publish_AddPhoto_TVC : UITableViewCell
@property (nonatomic,strong)CustomAddPhotoView *photoView;
@property (nonatomic,copy)void(^PhotoViewBlock)(void);
@end
