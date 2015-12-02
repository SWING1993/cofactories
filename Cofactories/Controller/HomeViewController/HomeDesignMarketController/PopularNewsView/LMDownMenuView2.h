//
//  LMDownMenuView2.h
//  美团下拉菜单
//
//  Created by 赵广印 on 15/11/6.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    SelectTypeOfCategory = 0,//类别
    SelectTypeOfClass, //位置
    SelectTypeOfPlace,//排序
} SelectType;

@interface LMDownMenuView2 : UIView
<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) void(^removeTheView)(BOOL cando);  //移除视图

@property (nonatomic,strong) void (^updateTitle)(NSString* selectItemStr);//更新选项卡标题
@property (nonatomic, strong) void(^selected)(SelectType type, NSString* currItemId);

- (id)initWithFrame:(CGRect)frame withSelectType:(SelectType)type levelArray:(NSArray *)levelArr classArray:(NSArray *)classArr addressArray:(NSArray *)addressArr andTitle:(NSString*)title;

- (void)tappedCancel;
- (void)tappedCancel2;

@end
