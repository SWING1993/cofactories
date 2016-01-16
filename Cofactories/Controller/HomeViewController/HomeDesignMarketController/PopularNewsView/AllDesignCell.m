//
//  AllDesignCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/2.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "AllDesignCell.h"

@implementation AllDesignCell{
    UILabel *_businessLB;
}

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
        
        self.designTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.designPhoto.frame) + 15, 10, kScreenW - 15 - 35 - 20 - 90, 25)];
        self.designTitle.font = [UIFont systemFontOfSize:12.f];
        self.designTitle.textColor = [UIColor colorWithRed:38.0f/255.0f green:38.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
        [self addSubview:self.designTitle];
        
        self.classTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.designTitle.frame.origin.x, CGRectGetMaxY(self.designTitle.frame), 80, 25)];
        self.classTitle.font = [UIFont systemFontOfSize:12.f];
        self.classTitle.textColor = [UIColor colorWithRed:158.0f/255.0f green:158.0f/255.0f blue:158.0f/255.0f alpha:1.0f];
        [self addSubview:self.classTitle];
        
        self.addressTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.classTitle.frame), self.classTitle.frame.origin.y, kScreenW - 80 - 80 - 15 - 35 - 20 - 10-5, 25)];
        self.addressTitle.font = [UIFont systemFontOfSize:12.f];
        self.addressTitle.textColor = [UIColor colorWithRed:158.0f/255.0f green:158.0f/255.0f blue:158.0f/255.0f alpha:1.0f];
        [self addSubview:self.addressTitle];
        
        _businessLB = [[UILabel alloc] initWithFrame:CGRectMake(self.designTitle.frame.origin.x, CGRectGetMaxY(self.designTitle.frame)+25, 120, 25)];
        _businessLB.font = [UIFont systemFontOfSize:12.f];
        _businessLB.textColor = [UIColor grayColor];
        [self.contentView addSubview:_businessLB];
        
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(0, 80 + 15 - 0.3, kScreenW, 0.3);
        line.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:207.0f/255.0f alpha:1.0f].CGColor;
        [self.layer addSublayer:line];
        
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
   _businessLB.text = [NSString stringWithFormat:@"信用积分:%@",model.businessScore];
}


@end
