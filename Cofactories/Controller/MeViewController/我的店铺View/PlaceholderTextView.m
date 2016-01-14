//
//  PlaceholderTextView.m
//  
//
//  Created by Apple on 15-3-16.
//  Copyright (c) 2015年 Tsou. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView()<UITextViewDelegate>
{
    UILabel *PlaceholderLabel;
}

@end

@implementation PlaceholderTextView

- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}


- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    float left=5,top=2,hegiht=25;
    
    self.placeholderColor = [UIColor lightGrayColor];
    PlaceholderLabel=[[UILabel alloc] initWithFrame:CGRectMake(left, top
                                                               , CGRectGetWidth(self.frame)-2*left, hegiht)];
//    PlaceholderLabel.backgroundColor = [UIColor redColor];
    PlaceholderLabel.textColor=self.placeholderColor;
    [self addSubview:PlaceholderLabel];
    PlaceholderLabel.text=self.placeholder;
    
}
-(void)setPlaceholderFont:(UIFont *)placeholderFont
{
    PlaceholderLabel.font = self.placeholderFont?self.placeholderFont:[UIFont systemFontOfSize:14];
}

-(void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        PlaceholderLabel.hidden=YES;
    }
    else
    {
        PlaceholderLabel.text=placeholder;
        PlaceholderLabel.numberOfLines = 0;
    }
    _placeholder=placeholder;
}

-(void)DidChange:(NSNotification*)noti
{
    
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        PlaceholderLabel.hidden=YES;
    }
    
    if (self.text.length > 0) {
        PlaceholderLabel.hidden=YES;
    }
    else{
        PlaceholderLabel.hidden=NO;
    }
}

@end
