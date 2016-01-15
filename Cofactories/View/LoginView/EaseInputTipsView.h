//
//  EaseInputTipsView.h
//  Cofactories
//
//  Created by 宋国华 on 16/1/12.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EaseInputTipsViewType) {
    EaseInputTipsViewTypeLogin = 0,
    EaseInputTipsViewTypeRegister
};

@interface EaseInputTipsView : UIView
@property (strong, nonatomic) NSString *valueStr;
@property (nonatomic, assign, getter=isActive) BOOL active;
@property (nonatomic, assign, readonly) EaseInputTipsViewType type;

@property (nonatomic, copy) void(^selectedStringBlock)(NSString *);

+ (instancetype)tipsViewWithType:(EaseInputTipsViewType)type;
- (instancetype)initWithTipsType:(EaseInputTipsViewType)type;

- (void)refresh;
- (void)setY:(CGFloat)y;

@end
