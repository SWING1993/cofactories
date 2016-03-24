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
        self.newsType = dictionary[@"categoryInfo"][@"name"];
        self.newsImage = dictionary[@"sImg"];
        self.authorImage = dictionary[@"authorAvatar"];
        self.discriptions = dictionary[@"discription"];
        self.clickNum = [NSString stringWithFormat:@"%@", dictionary[@"clickNum"]];
        self.commentNum = [NSString stringWithFormat:@"%@", dictionary[@"commentNum"]];
        }
    return self;
}

+ (instancetype)getPopularNewsModelWithDictionary:(NSDictionary *)dictionary{
    
    return [[self alloc]initPopularNewsModelWithDictionary:dictionary];
}


@end
