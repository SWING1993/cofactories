//
//  WalletHistoryModel.m
//  Cofactories
//
//  Created by 宋国华 on 15/12/9.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "WalletHistoryModel.h"

@implementation WalletHistoryModel

/*
 @property (nonatomic,assign) CGFloat  fee;
 @property (nonatomic,retain) NSString * Walletid;
 @property (nonatomic,assign) NSString * type;
 @property (nonatomic,assign) NSString * status;
 @property (nonatomic,retain) NSString * createdTime;
 @property (nonatomic,retain) NSString * finishedTime;
 @property (nonatomic,retain) NSString * products;
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        
        if (![[dictionary objectForKey:@"_id"] isEqual:[NSNull null]]) {
            _Walletid = [dictionary objectForKey:@"_id"];
        }
        
        if (![[dictionary objectForKey:@"fee"] isEqual:[NSNull null]] ) {
            _fee = [[dictionary objectForKey:@"fee"] floatValue];
        }
        
        if (![[dictionary objectForKey:@"type"] isEqual:[NSNull null]] ) {
            _type = [dictionary objectForKey:@"type"];
        }
        
        if ( ![[dictionary objectForKey:@"status"] isEqual:[NSNull null]] ) {
            _status = [dictionary objectForKey:@"status"];
        }
        
        
        if (![[dictionary objectForKey:@"createdTime"] isEqual:[NSNull null]] ) {
            _createdTime = [dictionary objectForKey:@"createdTime"];
        }
        
        if (![[dictionary objectForKey:@"finishedTime"] isEqual:[NSNull null]] ) {
            _finishedTime = [dictionary objectForKey:@"finishedTime"];
        }
        
        if (![[dictionary objectForKey:@"products"] isEqual:[NSNull null]] ) {
            _products = [dictionary objectForKey:@"products"];
        }
    }
    return self;
}

@end
