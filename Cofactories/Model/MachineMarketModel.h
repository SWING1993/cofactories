//
//  MachineMarketModel.h
//  Cofactories
//
//  Created by GTF on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MachineMarketModel : NSObject

@property (nonatomic,copy)NSString *amount; // 每次卖出去的数量
@property (nonatomic,copy)NSString *createdAt;
@property (nonatomic,copy)NSString *deletedAt;
@property (nonatomic,copy)NSString *descriptions;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)NSArray *photoArray;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *sales; // 销售出去的次数
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *unit;
@property (nonatomic,copy)NSString *updatedAt;
@property (nonatomic,copy)NSString *userUid;

- (instancetype)initMachineMarketModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getMachineMarketModelWithDictionary:(NSDictionary *)dictionary;

@end
