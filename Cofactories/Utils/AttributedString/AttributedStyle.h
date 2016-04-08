//
//  AttributedStyle.h
//  Cofactories
//
//  Created by 赵广印 on 16/4/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AttributedStyle : NSObject
@property (nonatomic, strong) NSString *attributedName;
@property (nonatomic, strong) id value;
@property (nonatomic, assign) NSRange range;

/**
 *  便利构造器
 *
 *  @param attributedName 属性名字
 *  @param value         设置的值
 *  @param range         取值范围
 *
 *  @return 实例对象
 */

+ (AttributedStyle *)attributedName:(NSString *)attributedName value:(id)value range:(NSRange)range;

@end
