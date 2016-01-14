//
//  TimeAxis_TVC.h
//  TimeAxle
//
//  Created by GTF on 16/1/5.
//  Copyright © 2016年 GUY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeAxis_TVC : UITableViewCell
- (void)setData:(NSString *)string isFirst:(BOOL)isFirst isLast:(BOOL)isLast isOnlyOne:(BOOL)isOnlyOne;
+ (CGSize)getCellHeightWithString:(NSString *)string;
@end
