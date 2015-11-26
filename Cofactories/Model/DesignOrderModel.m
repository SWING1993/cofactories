//
//  DesignOrderModel.m
//  Cofactories
//
//  Created by GTF on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "DesignOrderModel.h"

@implementation DesignOrderModel

- (instancetype)initDesignOrderModelWithDictionary:(NSDictionary *)dictionary{
    if (self =[super init]) {
        
        NSString *creatString = dictionary[@"createdAt"];
        NSArray *creatArray = [Tools WithTime:creatString];
        self.createdAt = (NSString *)[creatArray firstObject];
        
        self.descriptions = dictionary[@"description"];
        self.ID = dictionary[@"id"];
        self.name = dictionary[@"name"];
        self.photoArray = dictionary[@"photo"];
        self.status = dictionary[@"status"];
        self.userUid = dictionary[@"userUid"];
        self.bidCount = dictionary[@"bidCount"];
    }
    return self;
}

+ (instancetype)getDesignOrderModelWithDictionary:(NSDictionary *)dictionary{
    return  [[self alloc] initDesignOrderModelWithDictionary:dictionary];
}

@end
