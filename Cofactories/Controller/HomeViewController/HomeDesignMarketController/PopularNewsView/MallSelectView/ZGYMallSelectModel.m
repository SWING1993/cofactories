//
//  ZGYMallSelectModel.m
//  MallOfCofactories
//
//  Created by 赵广印 on 16/4/16.
//  Copyright © 2016年 聚工科技. All rights reserved.
//

#import "ZGYMallSelectModel.h"

@implementation ZGYMallSelectModel
- (instancetype)initZGYmallSelectModdelWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.name = dictionary[@"name"];
        self.isSelect = [(NSNumber *)dictionary[@"isSelect"] boolValue];
        self.mark = dictionary[@"mark"];
    }
    return self;
}
+ (instancetype)getZGYmallSelectModdelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initZGYmallSelectModdelWithDictionary:dictionary];
}
@end
