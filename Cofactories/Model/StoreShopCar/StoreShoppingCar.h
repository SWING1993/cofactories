//
//  StoreShoppingCar.h
//  Cofactories
//
//  Created by 赵广印 on 16/1/18.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreShoppingCar : NSObject

+ (StoreShoppingCar *)mainStoreShoppingCar;

- (void)storeValue:(id)value withKey:(NSString *)key;
- (id)valueWithKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;



@end
