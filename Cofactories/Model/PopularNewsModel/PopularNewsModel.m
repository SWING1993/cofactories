//
//  PopularNewsModel.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/16.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "PopularNewsModel.h"

@implementation PopularNewsModel
- (instancetype)initPopularNewsModelWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.newsID = [NSString stringWithFormat:@"%@", dictionary[@"_id"]];
        self.newsTitle = dictionary[@"title"];
        self.newsAuthor = dictionary[@"author"];
        self.newsImage = dictionary[@"sImg"];
        self.discriptions = dictionary[@"discription"];
        self.likeNum = [NSString stringWithFormat:@"%@", dictionary[@"likeNum"]];
        self.commentNum = [NSString stringWithFormat:@"%@", dictionary[@"commentNum"]];
        }
    return self;
}

+ (instancetype)getPopularNewsModelWithDictionary:(NSDictionary *)dictionary{
    
    return [[self alloc]initPopularNewsModelWithDictionary:dictionary];
}


@end
