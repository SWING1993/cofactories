//
//  SupplierOrderModel.h
//  Cofactories
//
//  Created by GTF on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplierOrderModel : NSObject

@property(nonatomic,copy)NSString *bidCount;
@property(nonatomic,assign)CGFloat amount;
@property(nonatomic,copy)NSString *createdAt;
@property(nonatomic,copy)NSString *deletedAt;
@property(nonatomic,copy)NSString *descriptions;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSArray *photoArray;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *updatedAt;
@property(nonatomic,copy)NSString *userUid;

- (instancetype)initSupplierOrderModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getSupplierOrderModelWithDictionary:(NSDictionary *)dictionary;

@end
