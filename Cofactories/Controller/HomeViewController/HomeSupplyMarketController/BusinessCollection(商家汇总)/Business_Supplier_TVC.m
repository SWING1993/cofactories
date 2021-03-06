//
//  Market_TVC.m
//  ttttttt
//
//  Created by GTF on 15/11/24.
//  Copyright © 2015年 GUY. All rights reserved.
//

#import "Business_Supplier_TVC.h"

@implementation Business_Supplier_TVC{
    UIImageView *_marketImage;
    UILabel     *_marketNameLabel;
    UIImageView *_certifyImage;
    BOOL         _isShowCertifyImage;
    UILabel     *_marketCreditLabel;
    UILabel     *_marketMessageLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _marketImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 70)];
        _marketImage.contentMode = UIViewContentModeScaleAspectFill;
        _marketImage.clipsToBounds = YES;
        [self.contentView addSubview:_marketImage];
        
        for (int i = 0; i<3; i++) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 10+i*25, 200, 25)];
            [self.contentView addSubview:label];
            
            switch (i) {
                case 0:
                    _marketNameLabel = label;
                    _marketNameLabel.font = [UIFont systemFontOfSize:14];
                    break;
                    
                case 1:
                    _marketCreditLabel = label;
                    _marketCreditLabel.font = [UIFont systemFontOfSize:12];
                    _marketCreditLabel.textColor = [UIColor grayColor];
                    break;
                    
                case 2:
                    _marketMessageLabel = label;
                    _marketMessageLabel.font = [UIFont systemFontOfSize:12];
                    _marketMessageLabel.textColor = [UIColor grayColor];
                    break;
                default:
                    break;
            }
        }
        
        _certifyImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_certifyImage];
    }
    
    return self;
}

- (void)layoutSomeDataWithMarketModel:(Business_Supplier_Model *)model{

    _marketNameLabel.text = model.businessName;
    if ([model.businessScore isEqualToString:@"0"]) {
        _marketCreditLabel.text = @"信用积分 0";
        
    }else{
        _marketCreditLabel.text = [NSString stringWithFormat:@"信用积分 %@",model.businessScore];
    }
    _marketMessageLabel.text = [NSString stringWithFormat:@"%@",model.businessCity];
    
    CGSize textSize = [_marketNameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName]];
    _certifyImage.frame = CGRectMake(_marketNameLabel.frame.origin.x + textSize.width + 10, _marketNameLabel.frame.origin.y + 5, 15, 15);
    
//    if ([model.businessEnterprise isEqualToString:@"企业用户"]) {
//        _certifyImage.image = [UIImage imageNamed:@"企.png"];
//    }else if ([model.businessVerified isEqualToString:@"认证用户"]){
//        _certifyImage.image = [UIImage imageNamed:@"证.png"];
//    }else{
//        _certifyImage.image = nil;
//    }
    
    if ([model.userIdentity isEqualToString:@"企业用户"]) {
        _certifyImage.image = [UIImage imageNamed:@"企.png"];
    }else if ([model.userIdentity isEqualToString:@"认证用户"]){
        _certifyImage.image = [UIImage imageNamed:@"证.png"];
    }else{
        _certifyImage.image = nil;
    }

    [_marketImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI,model.businessUid]] placeholderImage:[UIImage imageNamed:@"placeHolderUserImage.png"]];
}

@end
