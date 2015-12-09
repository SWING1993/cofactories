//
//  StoreUserValue.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/23.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreUserValue : NSObject

+ (StoreUserValue *)sharedInstance;

- (void)storeValue:(id)value withKey:(NSString *)key;
- (id)valueWithKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

@end
