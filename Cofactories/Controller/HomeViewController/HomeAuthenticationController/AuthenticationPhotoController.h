//
//  AuthenticationPhotoController.h
//  Cofactories
//
//  Created by 赵广印 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenticationPhotoController : UITableViewController
@property (nonatomic, strong) NSString *priseName;
@property (nonatomic, strong) NSString *priseAddress;
@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *idCard;

@property (nonatomic, assign) BOOL homeEnter;//判断是不是首页进入的

@end
