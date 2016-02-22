//
//  MallOrderDetailModel.h
//  Cofactories
//
//  Created by 赵广印 on 16/2/22.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MallOrderDetailModel : NSObject

@property (nonatomic, strong) NSArray *photoArray;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *amount;//购买数量
@property (nonatomic, strong) NSString *totalPrice;
@property (nonatomic, strong) NSString *descriptions;
@property (nonatomic, strong) NSString *waitPayType;


- (instancetype)initMallOrderDetailModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getMallOrderDetailModelWithDictionary:(NSDictionary *)dictionary;

@end
