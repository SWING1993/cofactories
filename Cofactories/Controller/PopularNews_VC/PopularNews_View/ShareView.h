//
//  ShareView.h
//  Cofactories
//
//  Created by 赵广印 on 16/4/9.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView

/**标题*/
@property (nonatomic, strong) NSString *title;
/**内容简介*/
@property (nonatomic, strong) NSString *message;
/**分享展示的图片*/
@property (nonatomic, strong) NSString *pictureName;
/**跳转链接*/
@property (nonatomic, strong) NSString *shareUrl;
/**当前视图控制器*/
@property (nonatomic, strong) UIViewController *myViewController;

- (void)showShareView;

@end
