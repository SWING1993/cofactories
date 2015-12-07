//
//  Market_TVC.m
//  ttttttt
//
//  Created by GTF on 15/11/24.
//  Copyright © 2015年 GUY. All rights reserved.
//

#import "Market_TVC.h"

@implementation Market_TVC{
    UIImageView *_marketImage;
    UILabel     *_marketNameLabel;
    UIImageView *_certifyImage;
    BOOL         _isShowCertifyImage;
    UILabel     *_marketCreditLabel;
    UILabel     *_marketMessageLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _marketImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 70)];
        _marketImage.backgroundColor = [UIColor yellowColor];
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

- (void)layoutSomeDataWithMarketModel:(Market_Model *)marketModel{
    
    _marketNameLabel.text = @"新天地辅料厂家";
    _marketCreditLabel.text = @"789评价";
    _marketMessageLabel.text = @"面辅料      柯桥";
    
    CGSize textSize = [_marketNameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName]];
    _certifyImage.frame = CGRectMake(_marketNameLabel.frame.origin.x + textSize.width + 10, _marketNameLabel.frame.origin.y + 5, 15, 15);
    _certifyImage.image = [UIImage imageNamed:@"企.png"];

    
}

@end
