//
//  DataBaseHandle.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/8.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "DataBaseHandle.h"
#import "DataBaseManager.h"
#import "ShopCarModel.h"

@implementation DataBaseHandle
+ (DataBaseHandle *)mainDataBaseHandle {
    
    static DataBaseHandle *handle = nil;
    if (handle == nil) {
        handle = [[DataBaseHandle alloc] init];
        handle.shoppingCarArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return handle;
}

//创建表
- (void)createShoppingCarTable {
    sqlite3 *db = [DataBaseManager openDataBase];
    sqlite3_stmt *stmt = nil;
    //sql语句字符串
    
    //NSString *title, *imageURl, *guidePrice, *lowestPrice;
    //@property (nonatomic, assign) NSInteger ID;
    /*
     @property (nonatomic, assign) NSInteger shoppingID;
     @property (nonatomic, strong) NSString *shopCarTitle;
     @property (nonatomic, strong) NSString *shopCarColor;
     @property (nonatomic, strong) NSString *shopCarPrice;
     @property (nonatomic, assign) NSInteger shopCarNumber;
     @property (nonatomic, strong) NSString *photoUrl;
     */

    NSString *sqlString = [NSString stringWithFormat:@"create table if not exists \"ShoppingCarTable\" (\"id\" integer primary key, \"shoppingID\" text,\"shopCarTitle\" text,\"shopCarColor\" text,\"shopCarPrice\" text,\"shopCarNumber\" text, \"photoUrl\" text)"];
    
    int result = sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        char *error = nil;
        int result = sqlite3_exec(db, [sqlString UTF8String], NULL, NULL, &error);
        if (result == SQLITE_OK) {
                        DLog(@"表创建成功");
        } else {
                        DLog(@"表创建失败:%s", error);
        }
    }
    //关闭数据库
    [DataBaseManager closeDataBase];
}

//添加进入购物车
- (void)addShoppingCar:(ShopCarModel *)shoppingCar {
    sqlite3 *db = [DataBaseManager openDataBase];
    sqlite3_stmt *stmt = nil;
    
    if (shoppingCar.shopCarTitle != nil && shoppingCar.shopCarColor != nil && shoppingCar.shopCarPrice != nil && shoppingCar.shopCarNumber != nil && shoppingCar.photoUrl != nil && shoppingCar.shoppingID != nil) {
        NSString *sqlString = [NSString stringWithFormat:@"insert into \"ShoppingCarTable\" (\"shoppingID\", \"shopCarTitle\", \"shopCarColor\",\"shopCarPrice\",\"shopCarNumber\",\"photoUrl\") values (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", shoppingCar.shoppingID, shoppingCar.shopCarTitle, shoppingCar.shopCarColor, shoppingCar.shopCarPrice, shoppingCar.shopCarNumber, shoppingCar.photoUrl];
        
        //准备sql, 判断语句的正确性
        int result = sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &stmt, NULL);
        if (result == SQLITE_OK) {
            //执行语句
            char *error = nil;
            int result = sqlite3_exec(db, [sqlString UTF8String], NULL, NULL, &error);
            if (result == SQLITE_OK) {
                            DLog(@"添加成功!");
            } else {
                            DLog(@"添加失败:%s", error);
            }
        }
        
    }
    //关闭数据库
    [DataBaseManager closeDataBase];
}
//查询所有所有购物车信息
- (void)searchAllShoppingCar {
    [self.shoppingCarArray removeAllObjects];
    sqlite3 *db = [DataBaseManager openDataBase];
    sqlite3_stmt *stmt = nil;
    NSString *sqlString = [NSString stringWithFormat:@"select * from \"ShoppingCarTable\""];
    int result = sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            
            int ID = sqlite3_column_int(stmt, 0);
            const unsigned char *shoppingID = sqlite3_column_text(stmt, 1);
            const unsigned char *shopCarTitle = sqlite3_column_text(stmt, 2);
            const unsigned char *shopCarColor = sqlite3_column_text(stmt, 3);
            const unsigned char *shopCarPrice = sqlite3_column_text(stmt, 4);
            const unsigned char *shopCarNumber = sqlite3_column_text(stmt, 5);
            const unsigned char *photoUrl = sqlite3_column_text(stmt, 6);
            
            //创建DataBaseCar
            ShopCarModel *shopCarModel = [[ShopCarModel alloc] init];
            shopCarModel.ID = ID;
            shopCarModel.shoppingID = [NSString stringWithUTF8String:(const char *)shoppingID];
            shopCarModel.shopCarTitle = [NSString stringWithUTF8String:(const char *)shopCarTitle];
            shopCarModel.shopCarColor = [NSString stringWithUTF8String:(const char *)shopCarColor];
            shopCarModel.shopCarPrice = [NSString stringWithUTF8String:(const char *)shopCarPrice];
            shopCarModel.shopCarNumber = [NSString stringWithUTF8String:(const char *)shopCarNumber];
            shopCarModel.photoUrl = [NSString stringWithUTF8String:(const char *)photoUrl];
            
            [self.shoppingCarArray addObject:shopCarModel];
        }
    }
    [DataBaseManager closeDataBase];
}

//删除购物车信息
- (void)deleteShoppingCarWithID:(NSInteger)ID {
    sqlite3 *db = [DataBaseManager openDataBase];
    sqlite3_stmt *stmt = nil;
    NSString *sqlString = [NSString stringWithFormat:@"delete from \"ShoppingCarTable\" where \"id\" = %ld", ID];
    int result = sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        char *error = nil;
        int result = sqlite3_exec(db, [sqlString UTF8String], NULL, NULL, &error);
        if (result == SQLITE_OK) {
                        DLog(@"删除成功");
        } else {
                        DLog(@"删除失败:%s", error);
        }
    }
    //关闭数据库
    [DataBaseManager closeDataBase];
}



@end
