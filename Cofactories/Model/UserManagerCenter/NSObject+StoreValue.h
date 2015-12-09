//
//  NSObject+StoreValue.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/23.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (StoreValue)

- (void)storeValueWithKey:(NSString *)key;
+ (id)valueByKey:(NSString *)key;
- (void)removeValueForKey:(NSString *)key;

@end
