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
/*
 
 UserType_designer,    //设计者
 UserType_clothing,    //服装企业
 UserType_processing,  //加工配套
 UserType_supplier,    //供应商
 UserType_facilitator, //服务商
 */
- (instancetype)initWithArray {
    if (self) {
        self.UserTypeListArray = [[NSArray alloc]initWithObjects:@"设计者",@"服装企业",@"加工配套企业",@"供应商",@"服务商", nil];
        
        self.UserTypeArray = [[NSArray alloc]initWithObjects:@"designer",@"clothing",@"processing",@"supplier",@"facilitator", nil];
    }
    return self;

}
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        _role = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"role"]];
        
        if ([_role isEqualToString:@"designer"]) {
            _UserType = UserType_designer;
        }else if ([_role isEqualToString:@"clothing"]){
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

        _uid = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"uid"]];
        if ([_uid isEqualToString:@"<null>"]) {
            _uid = @"尚未填写";
        }

        _phone = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"phone"]];
        if ([_phone isEqualToString:@"<null>"]) {
            _phone = @"尚未填写";
        }

        _name = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"name"]];
        if ([_name isEqualToString:@"<null>"]) {
            _name = @"尚未填写";
        }
        
        _province = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"province"]];

        if ([_province isEqualToString:@"<null>"]) {
            _province = @"尚未填写";
        }
        _city = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"city"]];
        if ([_city isEqualToString:@"<null>"]) {
            _city = @"尚未填写";
        }
        _district = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"district"]];
        if ([_district isEqualToString:@"<null>"]) {
            _district = @"尚未填写";
        }
        _address =  [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"address"]];

        if ([_address isEqualToString:@"<null>"]) {
            _address = @"尚未填写";
        }
        _subRole = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"subRole"]];
        if ([_subRole isEqualToString:@"<null>"]) {
            _subRole = @"尚未填写";
        }
        
        
        if ([[dictionary objectForKey:@"scale"] isEqual:[NSNull null]]) {
            _scale = @"尚未填写";
        }else {
            NSInteger seletecdInt = [[dictionary objectForKey:@"scale"] integerValue] - 1;
            _scale = self.scaleArr[seletecdInt];
        }

        
        _inviteCode = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"inviteCode"]];
        if ([_inviteCode isEqualToString:@"<null>"]) {
            _inviteCode = @"尚未填写";
        }
        _rongToken = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"rongToken"]];
        if ([_rongToken isEqualToString:@"<null>"]) {
            _rongToken = @"尚未填写";
        }
        _verified = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"verified"]];
        if ([_verified isEqualToString:@"<null>"]) {
            _verified = @"尚未填写";
        }
        _enterprise = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"enterprise"]];
        if ([_enterprise isEqualToString:@"<null>"]) {
            _enterprise = @"尚未填写";
        }
        _score = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"score"]];
        if ([_score isEqualToString:@"<null>"]) {
            _score = @"尚未填写";
        }
        _lastActivity = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"lastActivity"]];
        if ([_lastActivity isEqualToString:@"<null>"]) {
            _lastActivity = @"尚未填写";
        }
        _descriptionString = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"description"]];
        if ([_descriptionString isEqualToString:@"<null>"]) {
            _descriptionString = @"尚未填写";
        }
        _createdAt = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"createdAt"]];
        if ([_createdAt isEqualToString:@"<null>"]) {
            _createdAt = @"尚未填写";
        }
        _updatedAt = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"updatedAt"]];
        if ([_updatedAt isEqualToString:@"<null>"]) {
            _updatedAt = @"尚未填写";
        }
        
        _photoArray = [[NSMutableArray alloc]initWithCapacity:0];
        _photoArray = [dictionary objectForKey:@"photo"];
        
        _verifyDic = [dictionary objectForKey:@"verify"];
        
        if ([_verifyDic isEqual:[NSNull null]]) {
            DLog(@"认证字典为空");
        } else {
            DLog(@"认证字典");
            _enterpriseName = _verifyDic[@"enterpriseName"];
            if ([_enterpriseName isEqualToString:@"<null>"]) {
                _enterpriseName = @"尚未填写";
            }
            _personName = _verifyDic[@"personName"];
            if ([_personName isEqualToString:@"<null>"]) {
                _personName = @"尚未填写";
            }
            _idCard = _verifyDic[@"idCard"];
            if ([_idCard isEqualToString:@"<null>"]) {
                _idCard = @"尚未填写";
            }
            _enterpriseAddress = _verifyDic[@"enterpriseAddress"];
            if ([_enterpriseAddress isEqualToString:@"<null>"]) {
                _enterpriseAddress = @"尚未填写";
            }
            _status = [_verifyDic[@"status"] integerValue];

            _verifyCreatedAt = _verifyDic[@"createdAt"];
            if ([_verifyCreatedAt isEqualToString:@"<null>"]) {
                _verifyCreatedAt = @"尚未填写";
            }
            _verifyUpdatedAt = _verifyDic[@"updatedAt"];
            if ([_verifyUpdatedAt isEqualToString:@"<null>"]) {
                _verifyUpdatedAt = @"尚未填写";
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
    return [[NSString alloc] initWithFormat:@"\nrole: %@\nUserType: %ld\nuid: %@\nphone: %@\nname: %@\nprovince: %@\ncity: %@\ndistrict: %@\naddress: %@\nsubRole: %@\nscale: %@\ninviteCode: %@\nrongToken: %@\nverified: %@\nenterprise: %@\nscore:%@\nlastActivity:%@\ndescriptionString:%@\ncreatedAt:%@\nupdatedAt:%@\nphotoArray:%@\nverifyDic:%@\nenterpriseName:%@\npersonName:%@\nidCard:%@\nenterpriseAddress:%@\nstatus:%ld\nverifyCreatedAt:%@\nverifyUpdatedAt:%@", _role, (long)_UserType, _uid, _phone, _name, _province, _city, _district, _address, _subRole, _scale, _inviteCode, _rongToken, _verified, _enterprise, _score, _lastActivity, _descriptionString, _createdAt, _updatedAt, _photoArray, _verifyDic, _enterpriseName, _personName, _idCard, _enterpriseAddress, _status, _verifyCreatedAt, _verifyUpdatedAt];
}


@end
