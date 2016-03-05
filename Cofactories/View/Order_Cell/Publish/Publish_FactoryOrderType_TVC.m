//
//  Publish_OrderType_TVC.m
//  Cofactories
//
//  Created by GTF on 16/3/2.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import"Publish_FactoryOrderType_TVC.h"
// 解决针织梭织选择
@implementation Publish_FactoryOrderType_TVC{
    UILabel *_typeLB;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLB = [UILabel new];
        titleLB.font = [UIFont systemFontOfSize:14];
        NSString *string = [NSString stringWithFormat:@"%@ %@",@"*",@"订单类型"];
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
        titleLB.attributedText = attributedTitle;
        titleLB.frame = CGRectMake(15, 0, 70, 40);

        [self addSubview:titleLB];
        
        _typeLB = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, kScreenW-100, 40)];
        _typeLB.font = [UIFont systemFontOfSize:12];
        _typeLB.textColor = [UIColor lightGrayColor];
        [self addSubview:_typeLB];
    }
    return self;
}

- (void)setTypeString:(NSString *)typeString{
    _typeString = typeString;
    if (!typeString) {
        _typeLB.text = @"请点击右上角加号,选择订单类型";
    }else{
        _typeLB.text = typeString;
    }
}
@end
