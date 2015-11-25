//
//  IMChatViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/6.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "IMChatViewController.h"

@interface IMChatViewController ()

@end

@implementation IMChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [HttpClient getAccessoryDetailWithId:@"2" WithCompletionBlock:^(NSDictionary *dictionary) {
        
    }];
        // DLog(@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",model.amount,model.createdAt,model.descriptions,model.ID,model.name,model.price,model.photoArray,model.sales,model.type,model.part,model.userUid,model.country);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
