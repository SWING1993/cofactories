//
//  VerifyModel.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "VerifyModel.h"
/*
@property (nonatomic, strong) NSString *enterpriseName;
@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *idCard;
@property (nonatomic, strong) NSString *enterpriseAddress;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, assign) NSInteger userUid;
*/
@implementation VerifyModel

- (instancetype)initWithVerifyModelDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.enterpriseName = dictionary[@"enterpriseName"];
        self.personName = dictionary[@"personName"];
        self.idCard = dictionary[@"idCard"];
        self.enterpriseAddress = dictionary[@"enterpriseAddress"];
        self.status = [dictionary[@"status"] integerValue];
        self.verifyCreatedAt = dictionary[@"createdAt"];
        self.verifyUpdatedAt = dictionary[@"updatedAt"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"enterpriseName=%@, personName = %@, idCard = %@, enterpriseAddress = %@, status = %@, createdAt = %@, updatedAt = %@", self.enterpriseName, self.personName, self.idCard, self.enterpriseAddress, self.status, self.verifyCreatedAt, self.verifyUpdatedAt];
}

@end
