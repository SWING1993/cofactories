//
//  StoreUserValue.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/23.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "StoreUserValue.h"
#import "FastCoder.h"

static StoreUserValue * storeValue = nil;

@implementation StoreUserValue

+ (StoreUserValue *)sharedInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        storeValue = (StoreUserValue *)@"StoreUserValue";
        storeValue = [[StoreUserValue alloc] init];
    });
    // 防止子类使用
    NSString *classString = NSStringFromClass([self class]);
    if ([classString isEqualToString:@"StoreUserValue"] == NO) {
        NSParameterAssert(nil);
    }
    return storeValue;
}
- (instancetype)init {
    
    NSString *string = (NSString *)storeValue;
    if ([string isKindOfClass:[NSString class]] == YES && [string isEqualToString:@"StoreUserValue"]) {
        self = [super init];
        if (self) {
            // 防止子类使用
            NSString *classString = NSStringFromClass([self class]);
            if ([classString isEqualToString:@"StoreUserValue"] == NO) {
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
