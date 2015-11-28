//
//  VerifyModel.h
//  Cofactories
//
//  Created by 赵广印 on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyModel : NSObject
@property (nonatomic, strong) NSString *enterpriseName;
@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *idCard;
@property (nonatomic, strong) NSString *enterpriseAddress;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *verifyCreatedAt;
@property (nonatomic, strong) NSString *verifyUpdatedAt;
- (instancetype)initWithVerifyModelDictionary:(NSDictionary *)dictionary;
@end
