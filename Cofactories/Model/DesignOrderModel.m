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
        
        NSString *saleString = [NSString stringWithFormat:@"%@",dictionary[@"description"]];
        if ([saleString isEqualToString:@"<null>"] || saleString.length == 0){
            self.descriptions = @"商家未填写备注";
        }else{
            self.descriptions = dictionary[@"description"];
        }
        
        DLog(@"salestring====%@",saleString);
        
        self.ID = dictionary[@"id"];
        self.name = dictionary[@"name"];
        self.photoArray = dictionary[@"photo"];
        
        NSString *statusString = [NSString stringWithFormat:@"%@",dictionary[@"status"]];
        self.status = statusString;
        
        self.userUid = [NSString stringWithFormat:@"%@",dictionary[@"userUid"]];
        self.bidCount = [NSString stringWithFormat:@"%@",dictionary[@"bidCount"]];
    }
    return self;
}

+ (instancetype)getDesignOrderModelWithDictionary:(NSDictionary *)dictionary{
    return  [[self alloc] initDesignOrderModelWithDictionary:dictionary];
}

@end
