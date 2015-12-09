//
//  DataBaseHandle.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/8.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShopCarModel;

@interface DataBaseHandle : NSObject
@property (nonatomic, retain) NSMutableArray *shoppingCarArray;
+ (DataBaseHandle *)mainDataBaseHandle;
//创建表
- (void)createShoppingCarTable;

//添加进入购物车
- (void)addShoppingCar:(ShopCarModel *)shoppingCar;

//查询所有购物车信息
- (void)searchAllShoppingCar;

//删除购物车信息
- (void)deleteShoppingCarWithID:(NSInteger)ID;

@end
