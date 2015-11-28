//
//  ZGYDesignMarkrtController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ZGYDesignMarkrtController.h"
#import "PopularNewsController.h"
#import "PopularMessageController.h"

@interface ZGYDesignMarkrtController ()

@end

@implementation ZGYDesignMarkrtController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设计市场";
    
    for (int i = 0; i < 3; i++) {
        UIButton *designButton = [UIButton buttonWithType:UIButtonTypeCustom
                                  ];
        designButton.frame = CGRectMake(0, 64 + i*((kScreenH - 64)/3), kScreenW, (kScreenH - 64)/3);
        designButton.tag = 1000+ i;
        [designButton setImage:[UIImage imageNamed:@"男装新潮流"] forState:UIControlStateNormal];
        [designButton addTarget:self action:@selector(actionOfDesign:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:designButton];
    }


}

- (void)actionOfDesign:(UIButton *)button {
    switch (button.tag) {
        case 1000:{
            DLog(@"版型购买");
        }
            break;
        case 1001:{
            DLog(@"流行资讯");
//            PopularNewsController *popularVC = [[PopularNewsController alloc] initWithStyle:UITableViewStylePlain];
//            [self.navigationController pushViewController:popularVC animated:YES];
            PopularMessageController *popularVC = [[PopularMessageController alloc] init];
            [self.navigationController pushViewController:popularVC animated:YES];
            
        }
            break;
        case 1002:{
            DLog(@"设计者汇总");
        }
            break;

        default:
            break;
    }
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
