//
//  ActivityModel.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/30.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel
- (instancetype)initActivityModelWithDictionary:(NSDictionary *)dictionary{
    if (self =[super init]) {
        self.banner = dictionary[@"banner"];
        self.url = dictionary[@"url"];
    }
    return self;
}

+ (instancetype)getActivityModelWithDictionary:(NSDictionary *)dictionary{
    return  [[self alloc] initActivityModelWithDictionary:dictionary];
}

@end
