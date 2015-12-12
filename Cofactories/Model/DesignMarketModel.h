//
//  DesignMarketModel.h
//  Cofactories
//
//  Created by GTF on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignMarketModel : NSObject

@property (nonatomic,copy)NSString *amount; // 每次卖出去的数量
@property (nonatomic,copy)NSString *country;
@property (nonatomic,copy)NSString *createdAt;
@property (nonatomic,copy)NSString *descriptions;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *part;
@property (nonatomic,strong)NSArray *photoArray;
@property (nonatomic,strong)NSArray *categoryArray;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *marketPrice;
@property (nonatomic,copy)NSString *enterPrisePrice;//企业用户专享价
@property (nonatomic,copy)NSString *sales; // 销售出去的次数
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *market;//哪个市场
@property (nonatomic,copy)NSString *updatedAt;
@property (nonatomic,copy)NSString *userUid;

- (instancetype)initDesignMarketModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getDesignMarketModelWithDictionary:(NSDictionary *)dictionary;

@end
