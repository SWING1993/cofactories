//
//  UserModel.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/21.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "UserModel.h"
#import "StoreUserValue.h"

@implementation UserModel

- (instancetype)getMyProfile {
    UserModel * model  = [[StoreUserValue sharedInstance] valueWithKey:@"MyProfile"];
    return model;
}

+ (void)removeMyProfile {

    [[StoreUserValue sharedInstance] removeObjectForKey:@"MyProfile"];
}

- (instancetype)initWithArray {
    if (self) {
        self.UserTypeListArray = [[NSArray alloc]initWithObjects:@"设计者",@"服装企业",@"供应商",@"加工配套企业",@"服务商", nil];
        
        self.UserTypeArray = [[NSArray alloc]initWithObjects:@"designer",@"clothing",@"processing",@"supplier",@"facilitator", nil];
    }
    return self;

}
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        if ([dictionary objectForKey:@"role"] || ![[dictionary objectForKey:@"role"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"role"] isEqualToString:@"(null)"]) {
            
            _role = [dictionary objectForKey:@"role"];
            if ([_role isEqualToString:@"designer"]) {
                _UserType = UserType_designer;
            }else if ([_role isEqualToString:@"clothing"]){
                _UserType = UserType_clothing;
            }
            else if ([_role isEqualToString:@"processing"]){
                _UserType = UserType_processing;
            }
            else if ([_role isEqualToString:@"supplier"]){
                _UserType = UserType_supplier;
            }
            else if ([_role isEqualToString:@"facilitator"]){
                _UserType = UserType_facilitator;
            }
           
        }
        if ([dictionary objectForKey:@"uid"] || ![[dictionary objectForKey:@"uid"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"uid"] isEqualToString:@"(null)"]) {
            
            _uid = [dictionary objectForKey:@"uid"];
        }
        if ([dictionary objectForKey:@"phone"] || ![[dictionary objectForKey:@"phone"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"phone"] isEqualToString:@"(null)"]) {
            _phone = [dictionary objectForKey:@"phone"];
        }
        if ([dictionary objectForKey:@"name"] || ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"name"] isEqualToString:@"(null)"]) {
            _name = [dictionary objectForKey:@"name"];

        }
        if ([dictionary objectForKey:@"province"] || ![[dictionary objectForKey:@"province"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"province"] isEqualToString:@"(null)"]) {
            _province = [dictionary objectForKey:@"province"];

        }
        if ([dictionary objectForKey:@"city"] || ![[dictionary objectForKey:@"city"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"city"] isEqualToString:@"(null)"]) {
            _city = [dictionary objectForKey:@"city"];

        }
        if ([dictionary objectForKey:@"district"] || ![[dictionary objectForKey:@"district"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"district"] isEqualToString:@"(null)"]) {
            _district = [dictionary objectForKey:@"district"];

        }
        if ([dictionary objectForKey:@"address"] || ![[dictionary objectForKey:@"address"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"address"] isEqualToString:@"(null)"]) {
            _address = [dictionary objectForKey:@"address"];

        }
        if ([dictionary objectForKey:@"subRole"] || ![[dictionary objectForKey:@"subRole"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"subRole"] isEqualToString:@"(null)"]) {
            _subRole = [dictionary objectForKey:@"subRole"];

        }
        if ([dictionary objectForKey:@"scale"] || ![[dictionary objectForKey:@"scale"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"scale"] isEqualToString:@"(null)"]) {
            _scale = [dictionary objectForKey:@"scale"];

        }
        if ([dictionary objectForKey:@"inviteCode"] || ![[dictionary objectForKey:@"inviteCode"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"inviteCode"] isEqualToString:@"(null)"]) {
            _inviteCode = [dictionary objectForKey:@"inviteCode"];

        }
        if ([dictionary objectForKey:@"rongToken"] || ![[dictionary objectForKey:@"rongToken"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"rongToken"] isEqualToString:@"(null)"]) {
            _rongToken = [dictionary objectForKey:@"rongToken"];

        }
        if ([dictionary objectForKey:@"verified"] || ![[dictionary objectForKey:@"verified"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"verified"] isEqualToString:@"(null)"]) {
            _verified = [dictionary objectForKey:@"verified"];

        }
        if ([dictionary objectForKey:@"enterprise"] || ![[dictionary objectForKey:@"enterprise"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"enterprise"] isEqualToString:@"(null)"]) {
            _enterprise = [dictionary objectForKey:@"enterprise"];

        }
        if ([dictionary objectForKey:@"score"] || ![[dictionary objectForKey:@"score"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"score"] isEqualToString:@"(null)"]) {
            _score = [dictionary objectForKey:@"score"];

        }
        if ([dictionary objectForKey:@"lastActivity"] || ![[dictionary objectForKey:@"lastActivity"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"lastActivity"] isEqualToString:@"(null)"]) {
            _lastActivity = [dictionary objectForKey:@"lastActivity"];

        }
        if ([dictionary objectForKey:@"description"] || ![[dictionary objectForKey:@"description"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"description"] isEqualToString:@"(null)"]) {
            _descriptionString = [dictionary objectForKey:@"description"];

        }
        if ([dictionary objectForKey:@"createdAt"] || ![[dictionary objectForKey:@"createdAt"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"createdAt"] isEqualToString:@"(null)"]) {
            _createdAt = [dictionary objectForKey:@"createdAt"];

        }
        if ([dictionary objectForKey:@"updatedAt"] || ![[dictionary objectForKey:@"updatedAt"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"enterprise"] isEqualToString:@"(null)"]) {
            _updatedAt = [dictionary objectForKey:@"updatedAt"];

        }
        if ([dictionary objectForKey:@"verify"] || ![[dictionary objectForKey:@"verify"] isEqual:[NSNull null]] || [[dictionary objectForKey:@"verify"] isEqualToString:@"(null)"]) {
            _verifyDic = [dictionary objectForKey:@"verify"];
        }
        
    }

    return self;
}


@end
