//
//  ZGYMallSelectView.h
//  MallOfCofactories
//
//  Created by 赵广印 on 16/4/16.
//  Copyright © 2016年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGYMallSelectView;
@protocol ZGYMallSelectViewDelegate <NSObject>

- (void)selectView:(ZGYMallSelectView *)selectView moreSelectDic:(NSDictionary *)moreSelectDic;

@end
@interface ZGYMallSelectView : UIView

@property (nonatomic, weak) id<ZGYMallSelectViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)reloadTitles:(CGRect)frame;

@end
