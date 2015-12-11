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
        
        NSString *roleString = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"role"]];
        if ([roleString isEqualToString:@"designer"]) {
            _role = @"设计者";
        }else if ([roleString isEqualToString:@"clothing"]) {
            _role = @"服装企业";
        }else if ([roleString isEqualToString:@"processing"]) {
            _role = @"加工配套";
        }else if ([roleString isEqualToString:@"supplier"]) {
            _role = @"供应商";
        }else if ([roleString isEqualToString:@"facilitator"]) {
            _role = @"服务商";
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
            _address = @"地址未填写";
        }
        _subRole = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"subRole"]];
        if ([_subRole isEqualToString:@"<null>"]) {
            _subRole = @"尚未填写";
        }
        
        
        NSString *scaleString = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"scale"]];
        
        if ([scaleString isEqualToString:@"<null>"]) {
            _scale = @"规模未填写";
        }else{
            
            if ([_role isEqualToString:@"服装企业"]) {
                NSArray *scaleArray = @[@"0-10万件",@"10-40万件", @"40-100万件", @"100--200万件", @"200万件以上"];
                int index = [scaleString intValue];
                _scale = scaleArray[index-1];
            }else if ([_role isEqualToString:@"加工配套"]){
                NSArray *scaleArray = @[@"0-2人",@"2-10人",  @"10-20人", @"20人以上"];
                int index = [scaleString intValue];
                _scale = scaleArray[index-1];
            }
            

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
