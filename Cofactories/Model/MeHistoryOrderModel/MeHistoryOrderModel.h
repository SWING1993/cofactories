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
@property (nonatomic, strong) NSString *waitPayType;

@property (nonatomic, strong) NSString *sellerUserId;
@property (nonatomic, strong) NSString *buyerUserId;
@property (nonatomic, strong) NSString *mallOrderTitle;//商城订单详情标题
@property (nonatomic, assign) NSInteger status;//订单状态
@property (nonatomic, strong) NSString *payTime;
@property (nonatomic, strong) NSString *sendTime;
@property (nonatomic, strong) NSString *receiveTime;
@property (nonatomic, strong) NSString *comment;//评论状态（1：买家评论过卖家没评， 2：卖家评论过买家没评， 3：双方已评，订单已完成）

@property (nonatomic, assign) BOOL showButton;

- (instancetype)initMeHistoryOrderModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getMeHistoryOrderModelWithDictionary:(NSDictionary *)dictionary;


@end
