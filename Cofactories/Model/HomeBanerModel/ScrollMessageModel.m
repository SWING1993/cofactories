//
//  ScrollMessageModel.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/17.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "ScrollMessageModel.h"

@implementation ScrollMessageModel
- (instancetype)initScrollMessageModelWithDictionary:(NSDictionary *)dictionary {
    if (self =[super init]) {
        self.name = [NSString stringWithFormat:@"%@", dictionary[@"user"][@"name"]];
        self.amount = [NSString stringWithFormat:@"%@", dictionary[@"amount"]];
    }
    return self;
}
+ (instancetype)getScrollMessageModelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initScrollMessageModelWithDictionary:dictionary];
}
@end
