//
//  IndexModel.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/30.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexModel : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *action;

- (instancetype)initIndexModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getIndexModelWithDictionary:(NSDictionary *)dictionary;
@end
