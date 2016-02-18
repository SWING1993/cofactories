//
//  NSObject+StoreValue.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/23.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "NSObject+StoreValue.h"
#import "StoreUserValue.h"

@implementation NSObject (StoreValue)


- (void)storeValueWithKey:(NSString *)key {
    NSParameterAssert(key);
    [[StoreUserValue sharedInstance] storeValue:self withKey:key];
}

+ (id)valueByKey:(NSString *)key {
    NSParameterAssert(key);
    return [[StoreUserValue sharedInstance] valueWithKey:key];
}

- (void)removeValueForKey:(NSString *)key {
    NSParameterAssert(key);
    [[StoreUserValue sharedInstance] removeObjectForKey:key];
}



@end
