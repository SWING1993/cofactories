//
//  UIView+Common.h
//  Cofactories
//
//  Created by 宋国华 on 16/1/13.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Common)
- (void)addGradientLayerWithColors:(NSArray *)cgColorArray locations:(NSArray *)floatNumArray startPoint:(CGPoint )aPoint endPoint:(CGPoint)endPoint;

@end
