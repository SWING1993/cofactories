//
//  OthersUserModel.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/30.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "OthersUserModel.h"

@implementation OthersUserModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _role = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"role"]];
        
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
        _verified = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"verified"]];
        if ([_verified isEqualToString:@"<null>"]) {
            _verified = @"非认证用户";
        }
        _enterprise = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"enterprise"]];
        if ([_enterprise isEqualToString:@"<null>"]) {
            _enterprise = @"非企业用户";
        }
        _score = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"score"]];
        if ([_score isEqualToString:@"<null>"]) {
            _score = @"尚未填写";
        }
        _descriptions = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"description"]];
        if ([_descriptions isEqualToString:@"<null>"]) {
            _descriptions = @"用户介绍暂无";
        }
        _photoArray = [[NSMutableArray alloc]initWithCapacity:0];
        _photoArray = [dictionary objectForKey:@"photo"];
    }
    return self;
}
@end
