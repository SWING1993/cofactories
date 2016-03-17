//
//  ZGYScrollView.h
//  ZGYScrollingView
//
//  Created by 赵广印 on 16/3/9.
//  Copyright © 2016年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol  ZGYScrollViewDelegate <NSObject>
//
//- (void)clickZGYScrollView:(int)tag;
//
//@end

@interface ZGYScrollView : UIView <UIScrollViewDelegate> {
    NSInteger page;
}

//@property (nonatomic, weak)id<ZGYScrollViewDelegate>deleagte;

@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic,strong)NSTimer *myTimer;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadMessageWithMessageArray:(NSArray *)messageArray;
@end
