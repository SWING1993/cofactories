//
//  ZGYMallSelectView.m
//  MallOfCofactories
//
//  Created by 赵广印 on 16/4/16.
//  Copyright © 2016年 聚工科技. All rights reserved.
//

#import "ZGYMallSelectView.h"
#import "ZGYMallDownView.h"
#import "ZGYKoreaSelectView.h"
static NSString *newSelect = nil;

@implementation ZGYMallSelectView {
    NSMutableArray *buttonsArray, *marksArray, *rootArray;
    BOOL isShow;//操作视图没有收起直接按其他按钮的情况
    NSInteger currTag;//当前选择的按钮Tag
    NSString *priceSelect;
    NSMutableDictionary *moreSelect;
    NSString *dateString;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSelectView:frame];
    }
    return self;
}

- (void)creatSelectView:(CGRect)frame {
    buttonsArray = [NSMutableArray array];
    marksArray = [NSMutableArray array];
    rootArray = [NSMutableArray array];
    float rootWidth = frame.size.width/3;
    float rootHeight = frame.size.height;
    
    for (int i = 0; i < 3; i++) {
        UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(i*rootWidth, 0, rootWidth, rootHeight)];
        rootView.tag = 222 + i;
        [self addSubview:rootView];
        [rootArray addObject:rootView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOfTap:)];
        [rootView addGestureRecognizer:tap];
        
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.image = [UIImage imageNamed:@"category1"];
        photoView.contentMode = UIViewContentModeCenter;
        [rootView addSubview:photoView];
        [marksArray addObject:photoView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.tag = 333 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [rootView addSubview:btn];
        [buttonsArray addObject:btn];
        
        if (i == 1) {
            [btn setTitleColor:kMainDeepBlue forState:UIControlStateSelected];
        }
        
    }
    for (int i = 0; i < 2; i++) {
        CALayer *line = [CALayer layer];
        line.backgroundColor = kLineGrayCorlor.CGColor;
        line.frame = CGRectMake(rootWidth*(i + 1), 10, 0.6, 25);
        [self.layer addSublayer:line];
    }
    CALayer *bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(0, kSelectViewHeight - 0.6, kScreenW, 0.6);
    bottomLine.backgroundColor = kLineGrayCorlor.CGColor;
    [self.layer addSublayer:bottomLine];
    
    UIButton *orderBtn = buttonsArray[0];
    [orderBtn addTarget:self action:@selector(actionOfMore:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *brandBtn = buttonsArray[1];
    [brandBtn addTarget:self action:@selector(actionOfNew:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *priceBtn = buttonsArray[2];
    [priceBtn addTarget:self action:@selector(actionOfPrice:) forControlEvents:UIControlEventTouchUpInside];
    [self reloadTitles:frame];
}
- (void)reloadTitles:(CGRect)frame  {
    float btnWidth = frame.size.width/3;
    for (int i = 0; i < buttonsArray.count; i++) {
        UIButton *myButton = buttonsArray[i];
        UIImageView *markView = marksArray[i];
        switch (i) {
            case 0: {
                [myButton setTitle:@"筛选" forState:UIControlStateNormal];
                
            }
                break;
            case 1: {
                [myButton setTitle:@"最新" forState:UIControlStateNormal];
                myButton.frame = CGRectMake(0, 0, btnWidth, kSelectViewHeight);
                markView.hidden = YES;
            }
                break;
            case 2: {
                [myButton setTitle:@"默认排序" forState:UIControlStateNormal];
                
            }
                break;
            default:
                break;
        }
        
    }
    [self reloadFrame];
}

- (void)reloadFrame {
    for (int i = 0; i < buttonsArray.count; i++) {
        
        UIButton *myButton = buttonsArray[i];
        UIImageView *markView = marksArray[i];
        NSString *title = myButton.titleLabel.text;
        if (i == 0 || i == 2) {
            CGSize size = [Tools getSize:title andFontOfSize:13];
            CGFloat jxWidth = (myButton.superview.bounds.size.width - size.width - 20)/2; //间隙宽度
            myButton.frame = CGRectMake(jxWidth, 0, size.width, kSelectViewHeight);
            markView.frame = CGRectMake(myButton.frame.origin.x+myButton.frame.size.width, 12.5, 20, 20);
        }
        
    }
}

- (void)actionOfTap:(UITapGestureRecognizer*)sender{
    
    NSInteger index = sender.view.tag-222;
    UIButton* btn = buttonsArray[index];
    switch (index) {
        case 0:{
            [self actionOfMore:btn];
            break;
        }
        case 1:{
            [self actionOfNew:btn];
            break;
        }
        case 2:{
            [self actionOfPrice:btn];
            break;
        }
        
        default:
            break;
    }
}

- (void)actionOfMore:(UIButton *)button {
    self.userInteractionEnabled = NO;
    [button setTitleColor:kMainDeepBlue forState:UIControlStateNormal];
    if (isShow) {
        if (currTag == button.tag) {
//            NSLog(@"移除");
            [self hideSelectView:button];
        } else {
//            NSLog(@"不用移除");
            [self hideSelectView:button];
            [self performSelector:@selector(showSelectViewOnBtn:) withObject:button afterDelay:0.4];
        }
    } else {
        [self showSelectViewOnBtn:button];
    }
}
- (void)actionOfNew:(UIButton *)button {
    
//    self.userInteractionEnabled = NO;
    if (button.selected == NO) {
        newSelect = @"最新";
        button.selected = YES;
        [self getTodayDate];
        if (moreSelect) {
            [moreSelect setObject:dateString forKey:@"createdAt"];
        } else {
            moreSelect = [NSMutableDictionary dictionaryWithCapacity:0];
            [moreSelect setObject:dateString forKey:@"createdAt"];
        }
        
        [self.delegate selectView:self moreSelectDic:moreSelect];
    }
    if (isShow) {
        if (currTag == button.tag) {
//            NSLog(@"移除");
            [self hideSelectView:button];
        } else {
//            NSLog(@"不用移除");
            [self hideSelectView:button];
            [self performSelector:@selector(showSelectViewOnBtn:) withObject:button afterDelay:0.4];
        }
    } else {
        [self showSelectViewOnBtn:button];
    }
}
- (void)actionOfPrice:(UIButton *)button {
    self.userInteractionEnabled = NO;
    [button setTitleColor:kMainDeepBlue forState:UIControlStateNormal];

    if (isShow) {
        if (currTag == button.tag) {
//            NSLog(@"移除");
            [self hideSelectView:button];
        } else {
//            NSLog(@"不用移除");
            [self hideSelectView:button];
            [self performSelector:@selector(showSelectViewOnBtn:) withObject:button afterDelay:0.4];
        }
    } else {
        [self showSelectViewOnBtn:button];
    }
}


- (void)showSelectViewOnBtn:(UIButton*)sender {
    //点击后箭头旋转180，变颜色
    currTag = sender.tag;
    UIImageView* currImgV = marksArray[currTag - 333];
    
    currImgV.image = [UIImage imageNamed:@"category2.png"];
    [UIView animateWithDuration:0.35 animations:^{
        currImgV.transform = CGAffineTransformRotate(currImgV.transform, -M_PI);
    } completion:^(BOOL ok){
        if (ok) {
            self.userInteractionEnabled = YES;
        }
    }];
    
    ZGYMallDownView *downMenuV = [[ZGYMallDownView alloc] initWithFrame:CGRectMake(0, 109, kScreenW, self.superview.bounds.size.height) withSelectType:currTag - 333];
    downMenuV.tag = 100;
    if (currTag == 333 || currTag == 335) {
        //    cityMenuV.backgroundColor = [UIColor redColor];
        [self.superview addSubview:downMenuV];
    }
    
    
    isShow = YES;
    
    //取消
    downMenuV.removeTheView = ^(BOOL ok){
        currImgV.image = [UIImage imageNamed:@"category1.png"];
        
        [UIView animateWithDuration:0.35 animations:^{
            currImgV.transform = CGAffineTransformRotate(currImgV.transform, M_PI);
        } completion:^(BOOL ok){
            if (ok) {
                self.userInteractionEnabled = YES;
                [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
                isShow = NO;
            }
        }];
    };
    
    downMenuV.selected = ^(SelectType type, NSString *selectString) {
        if (type == SelectTypeOfPrice) {
            UIButton *priceBtn = buttonsArray[1];
            if (priceBtn.selected) {
                priceBtn.selected = NO;
            }
            [sender setTitle:selectString forState:UIControlStateNormal];
            [self reloadFrame];
            priceSelect = selectString;
        }
    };
    
    
    downMenuV.moreSelected = ^(SelectType type, NSDictionary *moreSelectDic) {
        if (type == SelectTypeOfMore || type == SelectTypeOfPrice) {
            moreSelect = [NSMutableDictionary dictionaryWithDictionary:moreSelectDic];
        }
        UIButton *myButton = buttonsArray[1];
        if (myButton.selected) {
            [self getTodayDate];
            [moreSelect setObject:dateString forKey:@"createdAt"];
        }
        [self.delegate selectView:self moreSelectDic:moreSelect];
    };
    
    
}

- (void)hideSelectView:(UIButton *)sender {
    ZGYMallDownView *downMenuV = (ZGYMallDownView *)[self.superview viewWithTag:100];
    
    if (downMenuV) {
        [downMenuV tappedCancel];
    }
}

- (void)getTodayDate {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
}

@end
