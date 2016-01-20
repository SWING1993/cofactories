//
//  IndexModel.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/30.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "IndexModel.h"

@implementation IndexModel

- (instancetype)initIndexModelWithDictionary:(NSDictionary *)dictionary{
    if (self =[super init]) {
        self.img = dictionary[@"img"];
        self.url = dictionary[@"url"];
        self.action = dictionary[@"action"];
    }
    return self;
}

+ (instancetype)getIndexModelWithDictionary:(NSDictionary *)dictionary{
    return  [[self alloc] initIndexModelWithDictionary:dictionary];
}

@end
