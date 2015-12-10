//
//  DealComment_TVC.m
//  Cofactories
//
//  Created by GTF on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "DealComment_TVC.h"

@implementation DealComment_TVC{
    UIImageView  *_userImage;
    UILabel      *_userNameLB;
    UILabel      *_commentTimeLB;
    UILabel      *_commentContentLB;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _userImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        _userImage.layer.masksToBounds = YES;
        _userImage.layer.cornerRadius = 30;
        [self addSubview:_userImage];
        
        
        for (int i = 0; i<3; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 15+i*25, kScreenW-100, 25)];
            [self addSubview:label];
            switch (i) {
                case 0:
                    _userNameLB = label;
                    _userNameLB.font = [UIFont systemFontOfSize:14.f];
                    break;
                case 1:
                    _commentTimeLB = label;
                    _commentTimeLB.font = [UIFont systemFontOfSize:12.f];
                    _commentTimeLB.textColor = [UIColor grayColor];
                    break;
                case 2:
                    _commentContentLB = label;
                    _commentContentLB.font = [UIFont systemFontOfSize:14.f];
                    break;

                default:
                    break;
            }
        }
        
        CALayer *lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(0, 89, kScreenW, 0.5);
        lineLayer.backgroundColor = [UIColor grayColor].CGColor;
        [self.layer addSublayer:lineLayer];
    }
    return self;
}

- (void)layoutDataWithDealCommentModel:(DealComment_Model *)model{
    _userNameLB.text = model.name;
    _commentTimeLB.text = model.createdTime;
    _commentContentLB.text = model.commentString;
    [_userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI,model.userID]] placeholderImage:[UIImage imageNamed:@"headBtn.png"]];
}
@end
