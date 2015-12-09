//
//  AllDesignCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/2.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "AllDesignCell.h"

@implementation AllDesignCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.designPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        self.designPhoto.layer.cornerRadius = 25;
        self.designPhoto.clipsToBounds = YES;
        [self addSubview:self.designPhoto];
        
        self.levelPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.designPhoto.frame) - 17, CGRectGetMaxY(self.designPhoto.frame) - 17, 17, 17)];
        self.levelPhoto.layer.cornerRadius = 8.5;
        self.levelPhoto.clipsToBounds = YES;
        [self addSubview:self.levelPhoto];
        
        self.designTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.designPhoto.frame) + 15, 15, kScreenW - 15 - 35 - 20 - 90, 25)];
//        self.designTitle.backgroundColor = [UIColor grayColor];
        self.designTitle.font = [UIFont systemFontOfSize:15];
        self.designTitle.textColor = [UIColor colorWithRed:38.0f/255.0f green:38.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
        [self addSubview:self.designTitle];
        
        self.classTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.designTitle.frame.origin.x, CGRectGetMaxY(self.designTitle.frame), 80, 25)];
        self.classTitle.font = [UIFont systemFontOfSize:13];
        self.classTitle.textColor = [UIColor colorWithRed:158.0f/255.0f green:158.0f/255.0f blue:158.0f/255.0f alpha:1.0f];
        [self addSubview:self.classTitle];
        
        self.addressTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.classTitle.frame), self.classTitle.frame.origin.y, kScreenW - 80 - 80 - 15 - 35 - 20 - 10, 25)];
//        self.addressTitle.backgroundColor = [UIColor grayColor];
        self.addressTitle.font = [UIFont systemFontOfSize:13];
        self.addressTitle.textColor = [UIColor colorWithRed:158.0f/255.0f green:158.0f/255.0f blue:158.0f/255.0f alpha:1.0f];
        [self addSubview:self.addressTitle];

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80 - 0.3, kScreenW, 0.3)];
        lineView.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:207.0f/255.0f alpha:1.0f];
        [self addSubview:lineView];
        
    }
    return self;
}


- (void)layoutDataWith:(Business_Supplier_Model *)model{
    
    [_designPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI,model.businessUid]] placeholderImage:[UIImage imageNamed:@"headBtn.png"]];
   // DLog(@">>==%@",[NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI,model.businessUid]);
    
    if ([model.businessEnterprise isEqualToString:@"企业用户"]) {
        _levelPhoto.image = [UIImage imageNamed:@"企.png"];
    }else if ([model.businessVerified isEqualToString:@"认证用户"]){
        _levelPhoto.image = [UIImage imageNamed:@"证.png"];
    }else{
        _levelPhoto.image = nil;
    }
    
    _designTitle.text = model.businessName;
    _classTitle.text = model.businessSubrole;
    _addressTitle.text = model.businessCity;

}


@end
