//
//  DealComment_Model.m
//  Cofactories
//
//  Created by GTF on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "DealComment_Model.h"

@implementation DealComment_Model
- (instancetype)initDealCommentModelWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        NSString *commentString = [NSString stringWithFormat:@"%@",dictionary[@"comment"]];
        if ([commentString isEqualToString:@"<null>"]) {
            _commentString = @"商家未评论";
        }else{
            _commentString = commentString;
        }
        _createdTime = [NSString stringWithFormat:@"%@",dictionary[@"createdAt"]];

        NSDictionary *senderDictionary = dictionary[@"sender"];
        _name = senderDictionary[@"name"];
        _userID = senderDictionary[@"uid"];

    }
    return self;
}

+ (instancetype)getDealCommentModelWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initDealCommentModelWithDictionary:dictionary];
}
@end
