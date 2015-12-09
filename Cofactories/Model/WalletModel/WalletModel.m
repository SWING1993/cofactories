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
        
        if (![[dictionary objectForKey:@"cash"] isEqual:[NSNull null]]) {
            _cash = [[dictionary objectForKey:@"cash"] floatValue];
        }
        
        if (![[dictionary objectForKey:@"freeze"] isEqual:[NSNull null]] ) {
            _freeze = [[dictionary objectForKey:@"freeze"] floatValue];
        }
        if (![[dictionary objectForKey:@"id"] isEqual:[NSNull null]] ) {
            _Walletid = [dictionary objectForKey:@"id"];
        }
        if ( ![[dictionary objectForKey:@"money"] isEqual:[NSNull null]] ) {
            _money = [[dictionary objectForKey:@"money"]floatValue];
        }


        if (![[dictionary objectForKey:@"createdAt"] isEqual:[NSNull null]] ) {
            _createdAt = [dictionary objectForKey:@"createdAt"];
        }
           if (![[dictionary objectForKey:@"updatedAt"] isEqual:[NSNull null]] ) {
            _updatedAt = [dictionary objectForKey:@"updatedAt"];
        }
    }
    return self;
}
@end
