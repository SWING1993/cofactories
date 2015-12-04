//
//  ProcessingAndComplitonOrderModel.h
//  Cofactories
//
//  Created by GTF on 15/12/3.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessingAndComplitonOrderModel : NSObject
@property(nonatomic,copy)NSString  *createdAt;
@property(nonatomic,copy)NSString  *ID;
@property(nonatomic,copy)NSString  *orderType;
@property(nonatomic,strong)NSArray *photoArray;

- (instancetype)initProcessingAndComplitonOrderModelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)getProcessingAndComplitonOrderModelWithDictionary:(NSDictionary *)dictionary;
@end
