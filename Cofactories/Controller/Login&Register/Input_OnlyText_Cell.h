//
//  Input_OnlyText_Cell.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#define kCellIdentifier_Input_OnlyText_Cell_Text @"Input_OnlyText_Cell_Text"

#import <UIKit/UIKit.h>

@interface Input_OnlyText_Cell : UITableViewCell
@property (strong, nonatomic, readonly) UITextField *textField;

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString *);
@property (nonatomic,copy) void(^editDidBeginBlock)(NSString *);
@property (nonatomic,copy) void(^editDidEndBlock)(NSString *);

- (void)setPlaceholder:(NSString *)phStr value:(NSString *)valueStr;
+ (NSString *)randomCellIdentifierOfPhoneCodeType;
@end
