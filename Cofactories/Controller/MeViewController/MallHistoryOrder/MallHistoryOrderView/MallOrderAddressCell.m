//
//  MallHistoryOrderAddressCell.m
//  Cofactories
//
//  Created by 赵广印 on 16/2/17.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallOrderAddressCell.h"

@implementation MallOrderAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.addressView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 27, 25, 25)];
        self.addressView.image = [UIImage imageNamed:@"Me-MallAddress"];
        [self addSubview:self.addressView];
        self.personName = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, (kScreenW - 60)/2, 20)];
        self.personName.font = [UIFont systemFontOfSize:12];
        self.personName.textColor = [UIColor grayColor];
        [self addSubview:self.personName];
        self.personPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake((kScreenW - 60)/2 + 45, 10, CGRectGetWidth(self.personName.frame), 20)];
        self.personPhoneNumber.font = [UIFont systemFontOfSize:12];
        self.personPhoneNumber.textAlignment = NSTextAlignmentRight;
        self.personPhoneNumber.textColor = [UIColor grayColor];
        [self addSubview:self.personPhoneNumber];
        self.personAddress = [[UILabel alloc] initWithFrame:CGRectMake(self.personName.frame.origin.x, CGRectGetMaxY(self.personPhoneNumber.frame), kScreenW - 60, 40)];
        self.personAddress.numberOfLines = 0;
        self.personAddress.font = [UIFont systemFontOfSize:12];
        self.personAddress.textColor = [UIColor grayColor];
        [self addSubview:self.personAddress];

    }
    return self;
}
//购买订单
- (void)reloadReceiveAddressWithMallBuyHistoryModel:(MallBuyHistoryModel *)mallBuyHistoryModel {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.personName.text = [NSString stringWithFormat:@"收货人：%@", mallBuyHistoryModel.personName];
    self.personPhoneNumber.text = [NSString stringWithFormat:@"电话：%@", mallBuyHistoryModel.personPhone];
    CGSize size = [Tools getSize:[NSString stringWithFormat:@"收货地址：%@", mallBuyHistoryModel.personAddress] andFontOfSize:12 andWidthMake:kScreenW - 60];
    self.personAddress.frame = CGRectMake(45, CGRectGetMaxY(self.personName.frame) + 5, kScreenW - 60, size.height);
    self.addressView.frame = CGRectMake(10, (45 + size.height - 25)/2, 25, 25);
    self.personAddress.text = [NSString stringWithFormat:@"收货地址：%@", mallBuyHistoryModel.personAddress];
}

//出售订单
- (void)reloadReceiveAddressWithMallSellHistoryModel:(MallSellHistoryModel *)mallSellHistoryModel {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.personName.text = [NSString stringWithFormat:@"收货人：%@", mallSellHistoryModel.personName];
    self.personPhoneNumber.text = [NSString stringWithFormat:@"电话：%@", mallSellHistoryModel.personPhone];
    CGSize size = [Tools getSize:[NSString stringWithFormat:@"收货地址：%@", mallSellHistoryModel.personAddress] andFontOfSize:12 andWidthMake:kScreenW - 60];
    self.personAddress.frame = CGRectMake(45, CGRectGetMaxY(self.personName.frame) + 5, kScreenW - 60, size.height);
    self.addressView.frame = CGRectMake(10, (45 + size.height - 25)/2, 25, 25);
    self.personAddress.text = [NSString stringWithFormat:@"收货地址：%@", mallSellHistoryModel.personAddress];
}

@end
