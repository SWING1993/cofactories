//
//  ZGYScrollView.m
//  ZGYScrollingView
//
//  Created by 赵广印 on 16/3/9.
//  Copyright © 2016年 聚工科技. All rights reserved.
//

#import "ZGYScrollView.h"

#define kScrollViewHeight 60

@implementation ZGYScrollView

- (instancetype)initWithFrame:(CGRect)frame withMessageArray1:(NSArray *)messageArray1 withMessageArray2:(NSArray *)messageArray2 {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.array1 = [NSMutableArray arrayWithArray:messageArray1];
        [self.array1 insertObject:[messageArray1 lastObject] atIndex:0];
        [self.array1 addObject:[messageArray1 firstObject]];
        
        self.array2 = [NSMutableArray arrayWithArray:messageArray2];
        [self.array2 insertObject:[messageArray2 lastObject] atIndex:0];
        [self.array2 addObject:[messageArray2 firstObject]];
        
        self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScrollViewHeight)];
        self.myScrollView.bounces = NO;
        self.myScrollView.delegate = self;
        self.myScrollView.pagingEnabled = NO;
        self.myScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.myScrollView];
        for (int i = 0; i < messageArray1.count + 2; i++) {
            for (int j = 0; j< 2; j++) {
                UIView *redPoint = [[UIView alloc] initWithFrame:CGRectMake(15, 15 + 25*j + kScrollViewHeight*i, 5, 5)];
                redPoint.backgroundColor = [UIColor redColor];
                redPoint.layer.cornerRadius = 2.5;
                redPoint.clipsToBounds = YES;
                [self.myScrollView addSubview:redPoint];
            }
            
            UILabel *newsLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(25, 5 + i*kScrollViewHeight, kScreenW - 70, 25)];
            newsLabel1.font = [UIFont systemFontOfSize:14];
            newsLabel1.text = self.array1[i];
            newsLabel1.textColor = GRAYCOLOR(82);
            [self.myScrollView addSubview:newsLabel1];
            
            UILabel *newsLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(25, 30 + i*kScrollViewHeight, kScreenW - 70, 25)];
            newsLabel2.font = [UIFont systemFontOfSize:14];
            newsLabel2.text = self.array2[i];
            newsLabel2.textColor = GRAYCOLOR(82);
            [self.myScrollView addSubview:newsLabel2];
        }
        [self.myScrollView setContentOffset:CGPointMake(0, kScrollViewHeight) animated:NO];
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 45, 0, 25, 40)];
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
        if (scrollView.contentOffset.y == kScrollViewHeight*(self.array1.count - 1)) {
        //滑到最后一条时，再从第一条开始
        [self.myScrollView setContentOffset:CGPointMake(0, kScrollViewHeight) animated:NO];
    }
}

@end
