//
//  ShopCarModel.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/8.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ShopCarModel.h"

@implementation ShopCarModel


- (NSString *)description
{
    return [NSString stringWithFormat:@"shopCarTitle = %@, shopCarColor = %@, shopCarPrice = %@, shopCarNumber = %@, isSelect = %d, photoUrl = %@", self.shopCarTitle, self.shopCarColor, self.shopCarPrice, self.shopCarNumber, self.isSelect, self.photoUrl];
}

@end
