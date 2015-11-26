//
//  PhotoViewController.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

@property (nonatomic,assign)BOOL isMySelf;

@property (nonatomic,copy)NSString*userUid;

@property (nonatomic,copy) NSArray * photoArray;

@end
