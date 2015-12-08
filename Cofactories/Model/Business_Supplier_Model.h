//
//  Supplier_Business_Midel.h
//  Cofactories
//
//  Created by GTF on 15/12/8.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business_Supplier_Model : NSObject

@property (nonatomic,copy)NSString *businessUid;
@property (nonatomic,copy)NSString *businessName;
@property (nonatomic,copy)NSString *businessEnterprise;
@property (nonatomic,copy)NSString *businessVerified;
@property (nonatomic,copy)NSString *businessSubrole;
@property (nonatomic,copy)NSString *businessCity;
@property (nonatomic,copy)NSString *businessScore;

- (instancetype)initBusinessSupplierModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getBusinessSupplierModelWithDictionary:(NSDictionary *)dictionary;

@end
