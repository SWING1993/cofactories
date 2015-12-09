//
//  ShopCarModel.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/8.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCarModel : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, strong) NSString *shoppingID;
@property (nonatomic, strong) NSString *shopCarTitle;
@property (nonatomic, strong) NSString *shopCarColor;
@property (nonatomic, strong) NSString *shopCarPrice;
@property (nonatomic, strong) NSString *shopCarNumber;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSString *photoUrl;


@end
