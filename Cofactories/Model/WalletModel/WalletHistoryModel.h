//
//  WalletHistoryModel.h
//  Cofactories
//
//  Created by 宋国华 on 15/12/9.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletHistoryModel : NSObject

@property (nonatomic,assign) CGFloat  fee;//交易金额
@property (nonatomic,assign) NSString * type;//哪里的交易
@property (nonatomic,retain) NSString * createdTime;//创建时间
@property (nonatomic,retain) NSString * finishedTime;//更新时间

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
