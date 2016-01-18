//
//  ActivityModel.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/30.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *banner;


- (instancetype)initActivityModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getActivityModelWithDictionary:(NSDictionary *)dictionary;
@end
