//
//  DataBaseManager.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/8.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataBaseManager : NSObject
+ (sqlite3 *)openDataBase;
+ (void)closeDataBase;
@end
