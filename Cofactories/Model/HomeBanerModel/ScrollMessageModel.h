//
//  ScrollMessageModel.h
//  Cofactories
//
//  Created by 赵广印 on 16/3/17.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrollMessageModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *amount;

- (instancetype)initScrollMessageModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getScrollMessageModelWithDictionary:(NSDictionary *)dictionary;
@end
