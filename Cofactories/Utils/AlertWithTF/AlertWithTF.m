//
//  AlertWithTF.m
//  Alert
//
//  Created by GTF on 16/1/25.
//  Copyright © 2016年 GUY. All rights reserved.
//

#import "AlertWithTF.h"

@implementation AlertWithTF{
    UIViewController *_viewController;
}
- (void)loadAlertViewInVC:(UIViewController *)viewController withTitle:(NSString *)title message:(NSString *)message textFieldPlaceHolder:(NSString *)textFieldPlaceHolder handelTitle:(NSArray *)handelTitle tfText:(void(^)(NSDictionary *dictionary))statusAndTextBlock{
    
    _viewController = viewController;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加TextField
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = textFieldPlaceHolder;
    }];
    
    // 遍历处理事件
    [handelTitle enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:(NSString *)obj style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textField = alertController.textFields.firstObject;
            statusAndTextBlock(@{@"index":@(idx),@"text":textField.text});
        }];
        [alertController addAction:alertAction];
    }];

    // 添加至父视图
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
