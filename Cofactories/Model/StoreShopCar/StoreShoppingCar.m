//
//  StoreShoppingCar.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/18.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "StoreShoppingCar.h"
#import "FastCoder.h"

static StoreShoppingCar * storeValue = nil;

@implementation StoreShoppingCar
+ (StoreShoppingCar *)mainStoreShoppingCar {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        storeValue = (StoreShoppingCar *)@"StoreShoppingCar";
        storeValue = [[StoreShoppingCar alloc] init];
    });
    // 防止子类使用
    NSString *classString = NSStringFromClass([self class]);
    if ([classString isEqualToString:@"StoreShoppingCar"] == NO) {
        NSParameterAssert(nil);
    }
    return storeValue;
}

- (instancetype)init {
    
    NSString *string = (NSString *)storeValue;
    if ([string isKindOfClass:[NSString class]] == YES && [string isEqualToString:@"StoreShoppingCar"]) {
        self = [super init];
        if (self) {
            // 防止子类使用
            NSString *classString = NSStringFromClass([self class]);
            if ([classString isEqualToString:@"StoreShoppingCar"] == NO) {
                NSParameterAssert(nil);
            }
        }
        return self;
    } else {
        return nil;
    }
}

- (void)storeValue:(id)value withKey:(NSString *)key {
    NSParameterAssert(value);
    NSParameterAssert(key);
    
    NSData *data = [FastCoder dataWithRootObject:value];
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (id)valueWithKey:(NSString *)key {
    NSParameterAssert(key);
    
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return [FastCoder objectWithData:data];
}

- (void)removeObjectForKey:(NSString *)key {
    NSParameterAssert(key);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    DLog(@"删除数据（BOOL）= %d",[[NSUserDefaults standardUserDefaults] synchronize]);
}


@end
