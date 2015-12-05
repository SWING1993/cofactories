//
//  BidManage_Factory_Model.h
//  Cofactories
//
//  Created by GTF on 15/12/5.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BidManage_Factory_Model : NSObject

@property(nonatomic,copy)NSString  *userID;
@property(nonatomic,copy)NSString  *userphone;
@property(nonatomic,copy)NSString  *userName;
@property(nonatomic,strong)NSArray *photoArray;
@property(nonatomic,copy)NSString  *descriptions;

- (instancetype)initBidManage_Factory_ModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getBidManage_Factory_ModelWithDictionary:(NSDictionary *)dictionary;
@end
