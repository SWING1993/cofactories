//
//  Publish_AddPhoto_TVC.m
//  Cofactories
//
//  Created by GTF on 16/2/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "Publish_AddPhoto_TVC.h"
#import "CustomAddPhotoView.h"

@implementation Publish_AddPhoto_TVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _photoView = [[CustomAddPhotoView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 140)];
        __block typeof(self)weakSelf = self;
        _photoView.AddPhotoBlock = ^{
            
            weakSelf.PhotoViewBlock();
        };
        [self addSubview:_photoView];
    }
    return self;
}

@end
