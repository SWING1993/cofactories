//
//  ZGYSelectNumberView.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/7.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGYSelectNumberView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *amountTextfield;
@property (nonatomic, assign) NSInteger timeAmount;
@property (nonatomic, assign) NSInteger leaveCount;

- (id)initWithFrame:(CGRect)frame WithBeginAmount:(NSInteger)aAmount leaveCount:(NSInteger)aLeaveCount;

@end
