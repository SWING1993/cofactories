//
//  MallAddressModel.h
//  Cofactories
//
//  Created by 赵广印 on 16/1/28.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MallAddressModel : NSObject

@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *postNumber;
@property (nonatomic, strong) NSString *province, *city, *district;
@property (nonatomic, strong) NSString *detailAddress;
@property (nonatomic, assign) BOOL isSelect;


@end
