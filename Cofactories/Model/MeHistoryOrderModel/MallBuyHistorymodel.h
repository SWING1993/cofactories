//
//  MallBuyHistorymodel.h
//  Cofactories
//
//  Created by 赵广印 on 16/4/13.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MallBuyHistoryModel : NSObject
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
@property (nonatomic, strong) NSString *payTime;
@property (nonatomic, strong) NSString *sendTime;
@property (nonatomic, strong) NSString *receiveTime;
@property (nonatomic, strong) NSString *orderNumber;

@property (nonatomic, strong) NSString *sellerUserId;
@property (nonatomic, strong) NSString *buyerUserId;

@property (nonatomic, strong) NSString *waitPayType;//最上面的订单状态（橙色字体）
@property (nonatomic, strong) NSString *payType;//蓝色按钮里显示的字体
@property (nonatomic, strong) NSString *mallOrderTitle;//商城订单详情标题
@property (nonatomic, assign) NSInteger status;//订单状态（点击该订单跳转到别的页面再返回时，用来判断该订单属于哪一栏）
@property (nonatomic, strong) NSString *comment;//评论状态（1：买家评论过卖家没评， 2：卖家评论过买家没评， 3：双方已评，订单已完成）

@property (nonatomic, strong) NSString *payment;//判断是不是用企业账号付的款

@property (nonatomic, assign) BOOL showButton;

- (instancetype)initMallBuyHistorymodelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getMallBuyHistorymodelWithDictionary:(NSDictionary *)dictionary;

@end
