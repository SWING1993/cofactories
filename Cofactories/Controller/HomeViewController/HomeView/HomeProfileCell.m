//
//  HomeProfileCell.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/21.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "HomeProfileCell.h"
#define kPersonPhotoHeight 60
#define kPersonPhotoMargin 20
#define kVerifyPhotoHeight 50


@implementation HomeProfileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.personPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(kPersonPhotoMargin, kPersonPhotoMargin, kPersonPhotoHeight, kPersonPhotoHeight)];
//        self.personPhoto.contentMode = UIViewContentModeScaleAspectFit;
        self.personPhoto.layer.cornerRadius = kPersonPhotoHeight/2;
        self.personPhoto.clipsToBounds = YES;
        [self addSubview:self.personPhoto];
        
        self.stylePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(kPersonPhotoHeight + 2*kPersonPhotoMargin, 12.5, 15, 15)];
        [self addSubview:self.stylePhoto];
        
        self.personName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.stylePhoto.frame) + 10, 10, 200, 20)];
        self.personName.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.personName];
        for (int i = 0; i < 3; i++) {
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.stylePhoto.frame), CGRectGetMaxY(self.stylePhoto.frame) + i*15, 200, 15)];
            myLabel.font = [UIFont systemFontOfSize:12];
            myLabel.textColor = [UIColor darkGrayColor];
            switch (i) {
                case 0:
                    self.personScore = myLabel;
                    break;
                case 1:
                    self.personWallet = myLabel;
                    break;
                case 2:
                    self.personStyle = myLabel;
                    break;
                default:
                    break;
            }
            [self addSubview:myLabel];
        }
        self.personAddress = [UIButton buttonWithType:UIButtonTypeCustom];
        self.personAddress.frame = CGRectMake(CGRectGetMinX(self.stylePhoto.frame), CGRectGetMaxY(self.personStyle.frame), 200, 15);
        [self addSubview:self.personAddress];
        
        self.verifyPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        self.verifyPhoto.frame = CGRectMake(kScreenW - kVerifyPhotoHeight - kPersonPhotoMargin, kPersonPhotoMargin, kVerifyPhotoHeight, kVerifyPhotoHeight);
        self.verifyPhoto.backgroundColor = [UIColor  blackColor];
        [self addSubview:self.verifyPhoto];
        
        self.verifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.verifyPhoto.frame) - 10, CGRectGetMaxY(self.verifyPhoto.frame), kVerifyPhotoHeight + 10, 20)];
        self.verifyLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.verifyLabel];
        
    }
    return self;
}




@end
