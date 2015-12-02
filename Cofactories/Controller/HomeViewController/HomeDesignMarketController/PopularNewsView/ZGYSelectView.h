//
//  ZGYSelectView.h
//  美团下拉菜单
//
//  Created by 赵广印 on 15/11/6.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGYSelectView;
@protocol  ZGYSelectViewDelegate<NSObject>
- (void)selectView:(ZGYSelectView*)selectview selectAreaId:(NSString*)areaid andClassifyId:(NSString*)classifyid andRankId:(NSString*)rankId;
- (void)selectView:(ZGYSelectView*)selectview selectTitle:(NSString*)currTitle;

@end

@interface ZGYSelectView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btn_selectArea;
@property (weak, nonatomic) IBOutlet UIButton *btn_selectClass;
@property (weak, nonatomic) IBOutlet UIButton *btn_selectRank;
@property (weak, nonatomic) IBOutlet UIImageView *img_areaMark;
@property (weak, nonatomic) IBOutlet UIImageView *img_classMark;
@property (weak, nonatomic) IBOutlet UIImageView *img_rankMark;




@property (nonatomic, weak) id<ZGYSelectViewDelegate> delegate;

@property (nonatomic, assign) BOOL isNearView;//是三个选择的视图;
@property (nonatomic, assign) BOOL isSearchView;//是两个选择的视图;

- (id)initWithFrame:(CGRect)frame levelArray:(NSArray *)levelArr classArray:(NSArray *)classArr addressArray:(NSArray *)addressArr title:(NSString *)title;

- (void)relodateTitles;
- (void)hideSelectView;
- (void)hideSelectView2;




@end
