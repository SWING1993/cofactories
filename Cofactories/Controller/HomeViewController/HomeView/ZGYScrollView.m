//
//  ZGYScrollView.m
//  ZGYScrollingView
//
//  Created by 赵广印 on 16/3/9.
//  Copyright © 2016年 聚工科技. All rights reserved.
//

#import "ZGYScrollView.h"
#import "ScrollMessageModel.h"

#define kScrollViewHeight 60
#define kMessageCount 10
@implementation ZGYScrollView {
    NSMutableArray *upLabelArray, *downLabelArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        upLabelArray = [NSMutableArray arrayWithCapacity:0];
        downLabelArray = [NSMutableArray arrayWithCapacity:0];
        
        self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScrollViewHeight)];
        self.myScrollView.bounces = NO;
        self.myScrollView.delegate = self;
        self.myScrollView.pagingEnabled = NO;
        self.myScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.myScrollView];
        for (int i = 0; i < kMessageCount + 2; i++) {
            for (int j = 0; j < 2; j++) {
                UIView *redPoint = [[UIView alloc] initWithFrame:CGRectMake(15, 16 + 24*j + kScrollViewHeight*i, 5, 5)];
                redPoint.backgroundColor = [UIColor redColor];
                redPoint.layer.cornerRadius = 2.5;
                redPoint.clipsToBounds = YES;
                [self.myScrollView addSubview:redPoint];
            }
            
            UILabel *newsUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 7 + i*kScrollViewHeight, kScreenW - 70, 23)];
            newsUpLabel.font = [UIFont systemFontOfSize:12];
            newsUpLabel.textColor = GRAYCOLOR(82);
            [self.myScrollView addSubview:newsUpLabel];
            [upLabelArray addObject:newsUpLabel];
            
            UILabel *newsDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 30 + i*kScrollViewHeight, kScreenW - 70, 23)];
            newsDownLabel.font = [UIFont systemFontOfSize:12];
            newsDownLabel.textColor = GRAYCOLOR(82);
            [self.myScrollView addSubview:newsDownLabel];
            [downLabelArray addObject:newsDownLabel];
        }
        [self.myScrollView setContentOffset:CGPointMake(0, kScrollViewHeight) animated:NO];
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 44, 0, 24, 40)];
        photoView.image = [UIImage imageNamed:@"Home-聚工动态"];
        [self addSubview:photoView];
        
        [self addTimer];
    }
    return self;
}
- (void)addTimer {
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
}
- (void)runTimer {
    CGFloat y = kScrollViewHeight*(page + 2);
    [self.myScrollView setContentOffset:CGPointMake(0, y) animated:YES];
}
#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    page = scrollView.contentOffset.y/kScrollViewHeight - 1;
        if (scrollView.contentOffset.y == kScrollViewHeight*(kMessageCount + 2 - 1)) {
        //滑到最后一条时，再从第一条开始
        [self.myScrollView setContentOffset:CGPointMake(0, kScrollViewHeight) animated:NO];
    }
}

- (void)reloadMessageWithMessageArray:(NSArray *)messageArray {
    if (messageArray) {
        NSMutableArray *upArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *downArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 2*kMessageCount; i++) {
            if (i%2 == 0) {
                [array1 addObject:messageArray[i]];
            } else if (i%2 == 1) {
                [array2 addObject:messageArray[i]];
            }
        }
        upArray = [NSMutableArray arrayWithArray:array1];
        [upArray insertObject:[array1 lastObject] atIndex:0];
        [upArray addObject:[array1 firstObject]];
        
        downArray = [NSMutableArray arrayWithArray:array2];
        [downArray insertObject:[array2 lastObject] atIndex:0];
        [downArray addObject:[array2 firstObject]];
        
        for (int i = 0; i < kMessageCount + 2; i++) {
            UILabel *upLabel = upLabelArray[i];
            UILabel *downLabel = downLabelArray[i];
            ScrollMessageModel *upModel = upArray[i];
            ScrollMessageModel *downModel = downArray[i];
            upLabel.text = [NSString stringWithFormat:@"%@发布了%@件订单", upModel.name, upModel.amount];
            downLabel.text = [NSString stringWithFormat:@"%@发布了%@件订单", downModel.name, downModel.amount];
        }
    }
}

@end
