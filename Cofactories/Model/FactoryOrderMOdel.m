//
//  FactoryOrderMOdel.m
//  Cofactories
//
//  Created by GTF on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "FactoryOrderMOdel.h"

@implementation FactoryOrderMOdel

- (instancetype)initSupplierOrderModelWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.amount = dictionary[@"amount"];
        self.bidCount = dictionary[@"bidCount"];
        self.createdAt = dictionary[@"createdAt"];
        self.deadline = dictionary[@"deadline"];
        self.descriptions = dictionary[@"description"];
        self.ID = dictionary[@"id"];
        self.photoArray = dictionary[@"photo"];
        self.status = dictionary[@"status"];
        self.subRole = dictionary[@"subRole"];
        self.type = dictionary[@""];
        self.userUid = dictionary[@"userUid"];
    }
    return self;
}

+ (instancetype)getSupplierOrderModelWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initSupplierOrderModelWithDictionary:dictionary];
}

@end
