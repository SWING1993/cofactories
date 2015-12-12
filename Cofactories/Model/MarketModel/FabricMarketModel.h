//
//  FabricMarketModel.h
//  Cofactories
//
//  Created by GTF on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FabricMarketModel : NSObject

@property (nonatomic,copy)NSString *amount; // 每次卖出去的数量
@property (nonatomic,copy)NSString *createdAt;
@property (nonatomic,copy)NSString *deletedAt;
@property (nonatomic,copy)NSString *descriptions;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)NSArray *photoArray;
@property (nonatomic,strong)NSArray *catrgoryArray;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *marketPrice;
@property (nonatomic,copy)NSString *enterPrisePrice;//企业用户专享价
@property (nonatomic,copy)NSString *sales; // 销售出去的次数
@property (nonatomic,copy)NSString *unit;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *market;//什么市场
@property (nonatomic,copy)NSString *updatedAt;
@property (nonatomic,copy)NSString *userUid;

//设计市场专有
@property (nonatomic,copy)NSString *country;
@property (nonatomic,copy)NSString *part;//上衣，下衣，套装
@property (nonatomic,copy)NSString *productId;



- (instancetype)initFabricMarketModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getFabricMarketModelWithDictionary:(NSDictionary *)dictionary;

@end
