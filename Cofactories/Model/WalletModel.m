//
//  WalletModel.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "WalletModel.h"

@implementation WalletModel


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        if ([dictionary objectForKey:@"cash"] || ![[dictionary objectForKey:@"cash"] isEqual:[NSNull null]] ) {
            _cash = [dictionary objectForKey:@"cash"];
        }
        
        if ([dictionary objectForKey:@"createdAt"] || ![[dictionary objectForKey:@"createdAt"] isEqual:[NSNull null]] ) {
            _createdAt = [dictionary objectForKey:@"createdAt"];
        }
        if ([dictionary objectForKey:@"freeze"] || ![[dictionary objectForKey:@"freeze"] isEqual:[NSNull null]] ) {
            _freeze = [dictionary objectForKey:@"freeze"];
        }
        if ([dictionary objectForKey:@"id"] || ![[dictionary objectForKey:@"id"] isEqual:[NSNull null]] ) {
            _Walletid = [dictionary objectForKey:@"id"];
        }
        if ([dictionary objectForKey:@"money"] || ![[dictionary objectForKey:@"money"] isEqual:[NSNull null]] ) {
            _money = [dictionary objectForKey:@"money"];
        }
        if ([dictionary objectForKey:@"updatedAt"] || ![[dictionary objectForKey:@"updatedAt"] isEqual:[NSNull null]] ) {
            _updatedAt = [dictionary objectForKey:@"updatedAt"];
        }
    }
    return self;
}
@end
