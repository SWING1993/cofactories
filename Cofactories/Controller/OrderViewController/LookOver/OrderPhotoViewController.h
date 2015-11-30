//
//  OrderPhotoViewController.h
//  cofactory-1.1
//
//  Created by gt on 15/8/28.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPhotoViewController : UIViewController
- (id)initWithPhotoArray:(NSArray *)photoArray;
@property (nonatomic,copy) NSString *titleString;
@end
