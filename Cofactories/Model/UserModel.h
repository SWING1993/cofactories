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

@interface UserModel : NSObject

@property (nonatomic, strong) NSArray * UserTypeListArray;
@property (nonatomic, strong) NSArray * UserTypeArray;

@property (nonatomic, retain) NSString * role;
@property (nonatomic, assign) UserType UserType;

@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * district;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * subRole;
@property (nonatomic, retain) NSString * scale;
@property (nonatomic, retain) NSString * inviteCode;
@property (nonatomic, retain) NSString * rongToken;
@property (nonatomic, retain) NSString * verified;
@property (nonatomic, retain) NSString * enterprise;
@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSString * lastActivity;
@property (nonatomic, retain) NSString * descriptionString;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * updatedAt;
@property (nonatomic, copy)   NSMutableArray * photoArray;

@property (nonatomic, retain) NSDictionary * verifyDic;


@property (nonatomic, retain) NSString *enterpriseName;
@property (nonatomic, retain) NSString *personName;
@property (nonatomic, retain) NSString *idCard;
@property (nonatomic, retain) NSString *enterpriseAddress;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, retain) NSString *verifyCreatedAt;
@property (nonatomic, retain) NSString *verifyUpdatedAt;

@property (nonatomic, copy)   NSArray  *scaleArr;


- (instancetype)getMyProfile;
+ (void)removeMyProfile;
- (instancetype)initWithArray;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (NSString *)getRoleWith:(UserType )type;


@end
