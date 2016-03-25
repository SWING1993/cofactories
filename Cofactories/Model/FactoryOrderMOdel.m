//
//  FactoryOrderMOdel.m
//  Cofactories
//
//  Created by GTF on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "FactoryOrderMOdel.h"

@implementation FactoryOrderMOdel

- (instancetype)initSupplierOrderModelWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.amount = [NSString stringWithFormat:@"%@",dictionary[@"amount"]];
        self.bidCount = [NSString stringWithFormat:@"%@",dictionary[@"bidCount"]];
        NSString *creatString = dictionary[@"createdAt"];
        NSArray *creatArray = [Tools WithTime:creatString];
        self.createdAt = (NSString *)[creatArray firstObject];
        self.deadline = dictionary[@"deadline"];
        
        NSString *saleString = dictionary[@"description"];
                //DLog(@"---------++++%@",saleString);
        if ([saleString isEqualToString:@"<null>"] || [saleString isEqualToString:@"(null)"] || [Tools isBlankString:saleString] == YES){
            self.descriptions = @"商家未填写备注";
        }else{
            self.descriptions = dictionary[@"description"];
        }
        
        self.ID = dictionary[@"id"];
        self.photoArray = dictionary[@"photo"];
        
        NSString *statusString = [NSString stringWithFormat:@"%@",dictionary[@"status"]];
        self.status = statusString;
        
        self.subRole = dictionary[@"subRole"];
        
        NSString *typeString = [NSString stringWithFormat:@"%@",dictionary[@"type"]];
        if ([typeString isEqualToString:@"knit"]) {
            self.type = @"针织";
        }else if ([typeString isEqualToString:@"woven"]){
            self.type = @"梭织";
        }else{
            self.type = @"加工配套";
        }
        
        self.userUid = [NSString stringWithFormat:@"%@",dictionary[@"userUid"]];
        
        NSString *creditString = [NSString stringWithFormat:@"%@",dictionary[@"credit"]];
//        DLog(@"---------%@",creditString);
        if ([creditString isEqualToString:@"-1"] || [creditString isEqualToString:@"<null>"] || [creditString isEqualToString:@"null"] || creditString == nil) {
            self.credit = @"普通订单";
        }else{
            self.credit = @"担保订单";
        }
        
        self.creditMoney = creditString;
        
        NSString *winnerUid = [NSString stringWithFormat:@"%@",dictionary[@"orderWinnerUid"]];
        self.orderWinnerID = winnerUid;
        if ([winnerUid isEqualToString:@"<null>"] || [winnerUid isEqualToString:@"null"] || winnerUid == nil) {
            _orderWinner = @"无人中标";
        }else{
            _orderWinner = @"有人中标";
        }
        
//        DLog(@"++++====%@",_orderWinner);
        
        NSString *firstMoney = [NSString stringWithFormat:@"%@",dictionary[@"firstPay"]];
        self.fistPayCount = firstMoney;
        
        NSString *contractStatus = [NSString stringWithFormat:@"%@",dictionary[@"contract"]];
        self.contractStatus = contractStatus;

        _winnerName = dictionary[@"winnerName"];
        _winnerPhone = dictionary[@"winnerPhone"];
    }
    return self;
}

+ (instancetype)getSupplierOrderModelWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initSupplierOrderModelWithDictionary:dictionary];
}

@end
