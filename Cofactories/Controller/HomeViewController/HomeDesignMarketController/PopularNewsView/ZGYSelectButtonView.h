//
//  ZGYSelectButtonView.h
//  SBButtonSelect
//
//  Created by 赵广印 on 15/11/26.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGYSelectButtonView;
@protocol  ZGYSelectButtonViewDelegata<NSObject>

- (void)selectButtonView:(ZGYSelectButtonView *)selectButtonView selectButtonTag:(NSInteger)selectButtonTag;

@end




@interface ZGYSelectButtonView : UIView {
    UILabel *selectLabel1, *selectLabel2, *selectLabel3, *selectLabel4;
    NSMutableArray *array4Btn;
}

@property (nonatomic, weak)id<ZGYSelectButtonViewDelegata> delegate;





@end
