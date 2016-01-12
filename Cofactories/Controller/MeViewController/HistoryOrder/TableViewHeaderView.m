//
//  TableViewHeaderView.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/11.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "TableViewHeaderView.h"
#define kPhotoHeight 150
#define kLabelHeight 50
#define kMargin 50
@implementation TableViewHeaderView

- (id)initWithFrame:(CGRect)frame withImage:(NSString *)image withLabelText:(NSString *)labelText {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenW - kPhotoHeight)/2, (frame.size.height - kPhotoHeight - kLabelHeight)/2, kPhotoHeight, kPhotoHeight)];
        self.photoView.image = [UIImage imageNamed:image];
        [self addSubview:self.photoView];
        self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(self.photoView.frame), kScreenW - 2*kMargin, kLabelHeight)];
        self.myLabel.numberOfLines = 2;
        self.myLabel.textColor = [UIColor lightGrayColor];
        self.myLabel.font = [UIFont systemFontOfSize:14];
        self.myLabel.textAlignment = NSTextAlignmentCenter;
        self.myLabel.text = labelText;
        
        [self addSubview:self.myLabel];
    }
    return self;
}

@end
