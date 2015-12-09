//
//  DataBaseManager.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/8.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "DataBaseManager.h"

@implementation DataBaseManager
static sqlite3 *sqlite = nil;
+ (sqlite3 *)openDataBase{
    if (sqlite != nil) {
        return sqlite;
    }
    NSString *docmentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *databasePath = [docmentsPath stringByAppendingPathComponent:@"ShoppingCar.sqlite"];
    
    sqlite3_open([databasePath UTF8String], &sqlite);
    return sqlite;
}

+ (void)closeDataBase{
    sqlite3_close(sqlite);
    sqlite = nil;
}

@end
