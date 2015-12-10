//
//  WalletModel.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletModel : NSObject

@property (nonatomic,retain) NSString *Walletid;
@property (nonatomic,assign) CGFloat  cash;
@property (nonatomic,assign) CGFloat  freeze;
@property (nonatomic,assign) CGFloat  money;
@property (nonatomic,assign) CGFloat  credit;
@property (nonatomic,assign) CGFloat  maxWithDraw;
@property (nonatomic,retain) NSString *createdAt;
@property (nonatomic,retain) NSString *updatedAt;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
