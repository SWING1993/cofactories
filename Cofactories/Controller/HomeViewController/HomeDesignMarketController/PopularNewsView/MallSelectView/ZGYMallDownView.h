//
//  ZGYMallDownView.h
//  MallOfCofactories
//
//  Created by 赵广印 on 16/4/16.
//  Copyright © 2016年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SelectTypeOfMore = 0, //筛选
    SelectTypeOfNew, //最新
    SelectTypeOfPrice, //排序
} SelectType;


@interface ZGYMallDownView : UIView <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (nonatomic, strong) void(^removeTheView)(BOOL cando);  //移除视图
@property (nonatomic, strong) void(^selected)(SelectType type, NSString *selectString);
@property (nonatomic, strong) void(^moreSelected)(SelectType type, NSDictionary *moreSelectDic);
- (instancetype)initWithFrame:(CGRect)frame withSelectType:(SelectType)type;
- (void)tappedCancel;


@end
