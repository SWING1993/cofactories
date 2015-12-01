//
//  OthersUserModel.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/30.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OthersUserModel : NSObject

@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * district;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * subRole;
@property (nonatomic, retain) NSString * scale;
@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSString * verified;
@property (nonatomic, retain) NSString * enterprise;
@property (nonatomic, copy)   NSMutableArray * photoArray;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
