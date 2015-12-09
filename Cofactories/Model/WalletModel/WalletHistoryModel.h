//
//  WalletHistoryModel.h
//  Cofactories
//
//  Created by 宋国华 on 15/12/9.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletHistoryModel : NSObject

@property (nonatomic,assign) CGFloat  fee;
@property (nonatomic,retain) NSString * Walletid;
@property (nonatomic,assign) NSString * type;
@property (nonatomic,assign) NSString * status;
@property (nonatomic,retain) NSString * createdTime;
@property (nonatomic,retain) NSString * finishedTime;
@property (nonatomic,retain) NSString * products;



- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
