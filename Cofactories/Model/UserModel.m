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
        
        _role = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"role"]];
        
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
        _scale = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"scale"]];
        if ([_scale isEqualToString:@"<null>"]) {
            _scale = @"尚未填写";
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
        _verifyDic = [dictionary objectForKey:@"verify"];
        
    }

    return self;
}


@end
