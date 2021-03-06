//
//  UserModel.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/21.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserType) {
    UserType_designer,    //设计者
    UserType_clothing,    //服装企业
    UserType_processing,  //加工配套
    UserType_supplier,    //供应商
    UserType_facilitator, //服务商
    UserType_Null,        //null
};

typedef NS_ENUM(NSInteger, EnterpriseType) {
    EnterpriseType_noEnterprise,
    EnterpriseType_mainEnterprise,
    EnterpriseType_supEnterprise,
};

@interface UserModel : NSObject

@property (nonatomic, retain) NSArray * UserTypeListArray;
@property (nonatomic, retain) NSArray * UserTypeArray;

@property (nonatomic, retain ,readonly) NSString * role;
@property (atomic, assign ,readonly) UserType UserType;
@property (atomic, assign, readonly) EnterpriseType enterpriseType;

@property (nonatomic, retain, readonly) NSString * uid;
@property (nonatomic, retain, readwrite) NSString * phone;
@property (nonatomic, retain, readonly) NSString * name;
@property (nonatomic, retain, readonly) NSString * province;
@property (nonatomic, retain, readonly) NSString * city;
@property (nonatomic, retain, readonly) NSString * district;
@property (nonatomic, retain, readonly) NSString * address;
@property (nonatomic, retain, readonly) NSString * subRole;
@property (nonatomic, retain, readonly) NSString * scale;
@property (nonatomic, retain, readonly) NSString * inviteCode;
@property (nonatomic, retain, readonly) NSString * rongToken;
@property (nonatomic, retain, readonly) NSString * verified;
@property (nonatomic, retain, readonly) NSString * score;
@property (nonatomic, retain, readonly) NSString * lastActivity;
@property (nonatomic, retain, readonly) NSString * descriptionString;
@property (nonatomic, retain, readonly) NSString * createdAt;
@property (nonatomic, retain, readonly) NSString * updatedAt;
@property (nonatomic, retain, readonly) NSMutableArray * photoArray;
@property (nonatomic, retain, readonly) NSDictionary * verifyDic;
@property (nonatomic, retain, readonly) NSString *verify_enterpriseName;
@property (nonatomic, retain, readonly) NSString *verify_personName;
@property (nonatomic, retain, readonly) NSString *verify_idCard;
@property (nonatomic, retain, readonly) NSString *verify_enterpriseAddress;
@property (nonatomic, assign, readonly) NSInteger verify_status;
@property (nonatomic, retain, readonly) NSString *verify_CreatedAt;
@property (nonatomic, retain, readonly) NSString *verify_UpdatedAt;

@property (nonatomic, retain)   NSArray  *scaleArr;

+ (UserModel*)User;
- (UserModel*)getMyProfile;
+ (void)removeMyProfile;
- (instancetype)initWithArray;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (NSString *)getRoleWith:(UserType )type;

@end
