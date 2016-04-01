//
//  IMSearchResultModel.h
//  Cofactories
//
//  Created by 赵广印 on 16/3/31.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMSearchResultModel : NSObject

@property (nonatomic,copy)NSString *businessUid;
@property (nonatomic,copy)NSString *businessName;
//@property (nonatomic,copy)NSString *businessEnterprise;
//@property (nonatomic,copy)NSString *businessVerified;
@property (nonatomic,copy)NSString *businessSubrole;
@property (nonatomic,copy)NSString *businessCity;
@property (nonatomic,copy)NSString *businessScore;
@property (nonatomic,copy)NSString *businessScale;
@property (nonatomic, copy)NSString *userIdentity; //用户身份
@property (nonatomic, copy)NSString *searchString;

- (instancetype)initBusinessSupplierModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getBusinessSupplierModelWithDictionary:(NSDictionary *)dictionary;

@end
