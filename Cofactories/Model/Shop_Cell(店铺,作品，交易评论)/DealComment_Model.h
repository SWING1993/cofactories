//
//  DealComment_Model.h
//  Cofactories
//
//  Created by GTF on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealComment_Model : NSObject
@property (nonatomic,copy)NSString *commentString;
@property (nonatomic,copy)NSString *createdTime;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *userID;  // 评论者的uid

- (instancetype)initDealCommentModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getDealCommentModelWithDictionary:(NSDictionary *)dictionary;
@end
