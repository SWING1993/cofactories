//
//  FactoryOrderMOdel.h
//  Cofactories
//
//  Created by GTF on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FactoryOrderMOdel : NSObject

@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *bidCount;
@property(nonatomic,copy)NSString *createdAt;
@property(nonatomic,copy)NSString *deadline;
@property(nonatomic,copy)NSString *descriptions;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,strong)NSArray *photoArray;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *subRole;
@property(nonatomic,copy)NSString *updatedAt;
@property(nonatomic,copy)NSString *userUid;
@property(nonatomic,copy)NSString *credit;
@property(nonatomic,copy)NSString *creditMoney;
@property(nonatomic,copy)NSString *orderWinner;
@property(nonatomic,copy)NSString *fistPayCount;
@property(nonatomic,copy)NSString *orderWinnerID;
@property(nonatomic,copy)NSString *contractStatus;;

- (instancetype)initSupplierOrderModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getSupplierOrderModelWithDictionary:(NSDictionary *)dictionary;


@end
