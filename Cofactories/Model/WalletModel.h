//
//  WalletModel.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletModel : NSObject

@property (nonatomic,retain) NSString *cash;
@property (nonatomic,retain) NSString *createdAt;
@property (nonatomic,retain) NSString *freeze;
@property (nonatomic,retain) NSString *Walletid;
@property (nonatomic,retain) NSString *money;
@property (nonatomic,retain) NSString *updatedAt;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
