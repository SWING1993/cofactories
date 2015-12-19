//
//  MeHistoryOrderModel.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/17.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeHistoryOrderModel : NSObject

@property (nonatomic, strong) NSArray *photoArray;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *amount;//购买数量
@property (nonatomic, strong) NSString *totalPrice;
@property (nonatomic, strong) NSString *descriptions;

@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *personPhone;
@property (nonatomic, strong) NSString *personAddress;

@property (nonatomic, strong) NSString *creatTime;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *payType;

- (instancetype)initMeHistoryOrderModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getMeHistoryOrderModelWithDictionary:(NSDictionary *)dictionary;


@end