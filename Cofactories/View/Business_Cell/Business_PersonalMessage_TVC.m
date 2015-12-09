//
//  Business_PersonalMessage_TVC.m
//  Cofactories
//
//  Created by GTF on 15/12/9.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "Business_PersonalMessage_TVC.h"

@implementation Business_PersonalMessage_TVC{
    UIImageView      *_userImage;
    UILabel          *_userNameLB;
    UIImageView      *_userTypeImage; // 企业用户，认证用户，注册用户
    UILabel          *_userSubroleLB;
    UILabel          *_userAddressLB;
    UILabel          *_userScaleLB;
    UILabel          *_descriptionLB;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    return self;
}

- (void)layoutDataWithOtherUserModel:(OthersUserModel *)model{
    
}

@end
