//
//  PersonalShop_Model.h
//  Cofactories
//
//  Created by GTF on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalShop_Model : NSObject
@property (nonatomic,copy)NSString *goodsID; // 商品的id
@property (nonatomic,copy)NSString *goodsName;
@property (nonatomic,copy)NSString *goodsPrice;
@property (nonatomic,copy)NSString *goodsSales;
@property (nonatomic,strong)NSArray *photoArray;
- (instancetype)initPersonalShopModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getPersonalShopModelWithDictionary:(NSDictionary *)dictionary;
@end
