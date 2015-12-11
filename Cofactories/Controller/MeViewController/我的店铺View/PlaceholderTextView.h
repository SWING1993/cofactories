//
//  PlaceholderTextView.h
//  
//
//  Created by Apple on 15-3-16.
//  Copyright (c) 2015年 Tsou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property(copy,nonatomic) NSString     *placeholder;
@property(strong,nonatomic) UIColor    *placeholderColor;
@property(strong,nonatomic) UIFont     *placeholderFont;

@end
