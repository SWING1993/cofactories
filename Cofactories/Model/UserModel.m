//
//  UserModel.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/21.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "Login.h"
#import "UserModel.h"
#import "StoreUserValue.h"

static NSString * placeholderString = @"暂无";

@implementation UserModel
+ (UserModel*)User {
    UserModel * model  = [[StoreUserValue sharedInstance] valueWithKey:@"MyProfile"];
    return model;
}
- (UserModel*)getMyProfile {
    UserModel * model  = [[StoreUserValue sharedInstance] valueWithKey:@"MyProfile"];
    return model;
}

+ (void)removeMyProfile {
    [[StoreUserValue sharedInstance] removeObjectForKey:@"MyProfile"];
}
/*
 
 UserType_designer,    //设计者
 UserType_clothing,    //服装企业
 UserType_processing,  //加工配套
 UserType_supplier,    //供应商
 UserType_facilitator, //服务商
 */
- (instancetype)initWithArray {
    self = [super init];
    if (self) {
        self.UserTypeListArray = [[NSArray alloc]initWithObjects:@"设计者",@"服装企业",@"加工配套企业",@"供应商",@"服务商", nil];
        
        self.UserTypeArray = [[NSArray alloc]initWithObjects:@"designer",@"clothing",@"processing",@"supplier",@"facilitator", nil];
    }
    return self;

}
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        if (![[dictionary objectForKey:@"role"] isEqual:[NSNull null]]) {
            _role = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"role"]];
            if ([_role isEqualToString:@"designer"]) {
                _UserType = UserType_designer;
            }
            else if ([_role isEqualToString:@"clothing"]){
                _UserType = UserType_clothing;
                self.scaleArr = @[@"0万件-10万件",@"10万件-40万件", @"40万件-100万件", @"100万件--200万件", @"200万件以上"];
            }
            else if ([_role isEqualToString:@"processing"]){
                _UserType = UserType_processing;
                self.scaleArr = @[@"0人-2人",@"2人-10人",  @"10人-20人", @"20人以上"];
                
            }
            else if ([_role isEqualToString:@"supplier"]){
                _UserType = UserType_supplier;
            }
            else if ([_role isEqualToString:@"facilitator"]){
                _UserType = UserType_facilitator;
            }
            else {
                _UserType = UserType_Null;
            }
        }
        
       
        if ([[dictionary objectForKey:@"uid"] isEqual:[NSNull null]]) {
            
            _uid = placeholderString;
        }else{
            _uid = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"uid"]];
        }


        if ([[dictionary objectForKey:@"phone"] isEqual:[NSNull null]]) {
            _phone = placeholderString;
        }else {
            _phone = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"phone"]];

        }

        if ([[dictionary objectForKey:@"name"] isEqual:[NSNull null]]) {
            _name = placeholderString;
        }else {
            _name = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"name"]];

        }
        

        if ([[dictionary objectForKey:@"province"] isEqual:[NSNull null]]) {
            _province = placeholderString;
        }else {
            _province = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"province"]];
            
        }
        
        if ([[dictionary objectForKey:@"city"] isEqual:[NSNull null]]) {
            _city = placeholderString;
        }else {
            _city = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"city"]];
        }
        
        
        if ([[dictionary objectForKey:@"district"] isEqual:[NSNull null]]) {
            _district = placeholderString;
        }else {
            _district = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"district"]];
        }
        
        
        if ([[dictionary objectForKey:@"address"] isEqual:[NSNull null]]) {
            _address = placeholderString;
        }else {
            _address =  [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"address"]];
            
        }
        
        
        if ([[dictionary objectForKey:@"subRole"] isEqual:[NSNull null]]) {
            _subRole = placeholderString;
        }else {
            _subRole = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"subRole"]];

        }
        
        
        if ([[dictionary objectForKey:@"scale"] isEqual:[NSNull null]]) {
            _scale = placeholderString;
        }else {
            NSInteger seletecdInt = [[dictionary objectForKey:@"scale"] integerValue] - 1;

            if (_UserType == UserType_clothing && seletecdInt < 5) {
                _scale = self.scaleArr[seletecdInt];
            }
            else if (_UserType == UserType_processing && seletecdInt < 4) {
                _scale = self.scaleArr[seletecdInt];
            }
            else {
                _scale = placeholderString;
            }
        }
        
        if ([[dictionary objectForKey:@"inviteCode"] isEqual:[NSNull null]]) {
            _inviteCode = placeholderString;
        }else {
            _inviteCode = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"inviteCode"]];
        }
        
        if ([[dictionary objectForKey:@"rongToken"] isEqual:[NSNull null]]) {
            _rongToken = placeholderString;
        }else {
            _rongToken = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"rongToken"]];

        }
        
        if ([[dictionary objectForKey:@"verified"] isEqual:[NSNull null]]) {
            _verified = placeholderString;
        }else {
            _verified = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"verified"]];
        }
        
        if ([[dictionary objectForKey:@"enterprise"] isEqual:[NSNull null]]) {
            _enterpriseType = EnterpriseType_noEnterprise;
        } else if ([[dictionary objectForKey:@"enterprise"] isEqual:@"0"]){
            _enterpriseType = EnterpriseType_mainEnterprise;
        } else {
            _enterpriseType = EnterpriseType_supEnterprise;
        }
        
        if ([[dictionary objectForKey:@"score"] isEqual:[NSNull null]]) {
            _score = placeholderString;
        }else {
            _score = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"score"]];
        }
        
        
        if ([[dictionary objectForKey:@"lastActivity"] isEqual:[NSNull null]]) {
            _lastActivity = placeholderString;
        }else {
            _lastActivity = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"lastActivity"]];

        }
        
        
        if ([[dictionary objectForKey:@"description"] isEqual:[NSNull null]]) {
            _descriptionString = placeholderString;
        }else {
            _descriptionString = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"description"]];

        }
        
        if ([[dictionary objectForKey:@"createdAt"] isEqual:[NSNull null]]) {
            _createdAt = placeholderString;
        }else {
            _createdAt = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"createdAt"]];

        }
        
        if ([[dictionary objectForKey:@"updatedAt"] isEqual:[NSNull null]]) {
            _updatedAt = placeholderString;
        }else {
            _updatedAt = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"updatedAt"]];

        }
        
        _photoArray = [[dictionary objectForKey:@"photo"] mutableCopy];
        
        _verifyDic = [[dictionary objectForKey:@"verify"] copy];
        
        if ([[dictionary objectForKey:@"verify"] isEqual:[NSNull null]]) {
            DLog(@"认证字典为空");
        } else {
            DLog(@"认证字典");
            _verify_enterpriseName = _verifyDic[@"enterpriseName"];
            if ([_verify_enterpriseName isEqualToString:@"<null>"]) {
                _verify_enterpriseName = placeholderString;
            }
            _verify_personName = _verifyDic[@"personName"];
            if ([_verify_personName isEqualToString:@"<null>"]) {
                _verify_personName = placeholderString;
            }
            _verify_idCard = _verifyDic[@"idCard"];
            if ([_verify_idCard isEqualToString:@"<null>"]) {
                _verify_idCard = placeholderString;
            }
            _verify_enterpriseAddress = _verifyDic[@"enterpriseAddress"];
            if ([_verify_enterpriseAddress isEqualToString:@"<null>"]) {
                _verify_enterpriseAddress = placeholderString;
            }
            
            _verify_status = [_verifyDic[@"status"] integerValue];

            _verify_CreatedAt = _verifyDic[@"createdAt"];
            if ([_verify_CreatedAt isEqualToString:@"<null>"]) {
                _verify_CreatedAt = placeholderString;
            }
            _verify_UpdatedAt = _verifyDic[@"updatedAt"];
            if ([_verify_UpdatedAt isEqualToString:@"<null>"]) {
                _verify_UpdatedAt = placeholderString;
            }
        }
    }

    return self;
}

+ (NSString *)getRoleWith:(UserType )type {
    NSString * string = nil;
    switch (type) {
        case UserType_designer:
            string = @"设计者";
            break;
            
        case UserType_clothing:
            string = @"服装企业";
            break;
            
        case UserType_processing:
            string = @"加工配套";
            break;
            
        case UserType_supplier:
            string = @"供应商";
            break;
            
        case UserType_facilitator:
            string = @"服务商";
            break;
            
        default:
            string = @"暂无该身份";
            break;
    }
    return string;
}

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"\nrole: %@\nUserType: %ld\nuid: %@\nphone: %@\nname: %@\nprovince: %@\ncity: %@\ndistrict: %@\naddress: %@\nsubRole: %@\nscale: %@\ninviteCode: %@\nrongToken: %@\nverified: %@\nenterpriseType: %ld\nscore:%@\nlastActivity:%@\ndescriptionString:%@\ncreatedAt:%@\nupdatedAt:%@\nphotoArray:%@\nverifyDic:%@\nenterpriseName:%@\npersonName:%@\nidCard:%@\nenterpriseAddress:%@\nstatus:%ld\nverifyCreatedAt:%@\nverifyUpdatedAt:%@", _role, (long)_UserType, _uid, _phone, _name, _province, _city, _district, _address, _subRole, _scale, _inviteCode, _rongToken, _verified, _enterpriseType, _score, _lastActivity, _descriptionString, _createdAt, _updatedAt, _photoArray, _verifyDic, _verify_enterpriseName, _verify_personName, _verify_idCard, _verify_enterpriseAddress, (long)_verify_status, _verify_CreatedAt, _verify_UpdatedAt];
}


@end
