//
//  PopularNewsModel.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/16.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopularNewsModel : NSObject

@property (nonatomic, strong) NSString *newsID;
@property (nonatomic, strong) NSString *newsTitle;
@property (nonatomic, strong) NSString *newsAuthor;
@property (nonatomic, strong) NSString *newsType;
@property (nonatomic, strong) NSString *authorImage;
@property (nonatomic, strong) NSString *discriptions;
@property (nonatomic, strong) NSString *newsImage;
@property (nonatomic, strong) NSString *commentNum;
@property (nonatomic, strong) NSString *clickNum;

- (instancetype)initPopularNewsModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getPopularNewsModelWithDictionary:(NSDictionary *)dictionary;


@end
