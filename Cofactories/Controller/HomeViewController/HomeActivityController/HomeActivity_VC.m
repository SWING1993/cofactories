//
//  HomeActivity_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/18.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "HomeActivity_VC.h"
#import "PersonalMessage_Design_VC.h"
#import "PersonalMessage_Clothing_VC.h"
#import "PersonalMessage_Factory_VC.h"
#import "HomeShopList_VC.h"

@interface HomeActivity_VC ()<UIWebViewDelegate> {
    UIWebView * webView;
}


@end

@implementation HomeActivity_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[UIWebView alloc]initWithFrame:kScreenBounds];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    NSString *url = @"http://h5.test.cofactories.com/hanguodaigou-party/";
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.view addSubview:webView];
    [webView loadRequest:request];

//    [webView stringByEvaluatingJavaScriptFromString:@"myFunction();"];
//    // 注入js
//    
//    NSString *p = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
//    NSString *js = [NSString stringWithContentsOfFile:p encoding:NSUTF8StringEncoding error:nil];
//    [webView stringByEvaluatingJavaScriptFromString:js];
    
}
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    
//    NSString *requestString = [[request URL] absoluteString];
//    
//    // 中文乱码转换
//    NSLog(@"pre:%@",requestString);// pre:testapp:alert:%E4%BD%A0%E5%A5%BD%E5%90%97%EF%BC%9F
//    requestString = [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"cov:%@",requestString);// cov:testapp:alert:你好吗？
//    
//    
//    NSArray *components = [requestString componentsSeparatedByString:@":"];
//    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"cofactories"]) {
//        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"alert"])
//        {
//            DLog(@"^^^^^^^^^^ = %@", [components objectAtIndex:2]);
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:@"alert from html" message:[components objectAtIndex:2]
//                                  delegate:self cancelButtonTitle:nil
//                                  otherButtonTitles:@"OK", nil];
//            [alert show];
//        }
//        return NO;
//    }
//    return YES;
//}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    NSString *headerString = [requestString substringToIndex:14];
    DLog(@"#####%@", headerString);
    //判断是不是点击链接
    if ([headerString isEqualToString:@"cofactories://"]) {
        DLog(@"+++++%@", requestString);
        NSString *bigString = [requestString substringFromIndex:14];
        DLog(@"^^^^^^%@", bigString);
        NSArray *array = [bigString componentsSeparatedByString:@","];
        NSString *actionString = nil;
        for (NSString *string in array) {
            if ([string rangeOfString:@"action:"].location != NSNotFound) {
                actionString = string;
            }
        }
        //进商店
        if ([actionString rangeOfString:@"actio3n:GET%20OUT"].location != NSNotFound) {
            DLog(@"^^^^^^^^^^^#######");
            HomeShopList_VC *myShopVC = [[HomeShopList_VC alloc] init];
            [self.navigationController pushViewController:myShopVC animated:YES];
        }
        //进版型购买
        if ([actionString rangeOfString:@"action:GET%20OUT%20!"].location != NSNotFound) {
            NSString *uidString = nil;
            for (NSString *string in array) {
                if ([string rangeOfString:@"uid:"].location != NSNotFound) {
                    uidString = [string substringFromIndex:4];
                }
            }
            DLog(@"$$$$$$$$%@", uidString);
            [HttpClient getOtherIndevidualsInformationWithUserID:uidString WithCompletionBlock:^(NSDictionary *dictionary) {
                OthersUserModel *model = dictionary[@"message"];
                if ([model.role isEqualToString:@"设计者"] || [model.role isEqualToString:@"供应商"]) {
                    PersonalMessage_Design_VC *vc = [PersonalMessage_Design_VC new];
                    vc.userID = uidString;
                    vc.userModel = model;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                if ([model.role isEqualToString:@"服装企业"]) {
                    PersonalMessage_Clothing_VC *vc = [PersonalMessage_Clothing_VC new];
                    vc.userID = uidString;
                    vc.userModel = model;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                if ([model.role isEqualToString:@"加工配套"]) {
                    PersonalMessage_Factory_VC *vc = [PersonalMessage_Factory_VC new];
                    vc.userID = uidString;
                    vc.userModel = model;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }];
        }

//        if ([requestString rangeOfString:@"cofactories://shop:"].location !=NSNotFound) {
//            HomeShopList_VC *myShopVC = [[HomeShopList_VC alloc] init];
//            [self.navigationController pushViewController:myShopVC animated:YES];
//            
//        } else {
//            
//            [HttpClient getOtherIndevidualsInformationWithUserID:@"6" WithCompletionBlock:^(NSDictionary *dictionary) {
//                OthersUserModel *model = dictionary[@"message"];
//                if ([model.role isEqualToString:@"设计者"] || [model.role isEqualToString:@"供应商"]) {
//                    PersonalMessage_Design_VC *vc = [PersonalMessage_Design_VC new];
//                    vc.userID = @"6";
//                    vc.userModel = model;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                if ([model.role isEqualToString:@"服装企业"]) {
//                    PersonalMessage_Clothing_VC *vc = [PersonalMessage_Clothing_VC new];
//                    vc.userID = @"6";
//                    vc.userModel = model;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                if ([model.role isEqualToString:@"加工配套"]) {
//                    PersonalMessage_Factory_VC *vc = [PersonalMessage_Factory_VC new];
//                    vc.userID = @"6";
//                    vc.userModel = model;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                
//            }];
//        }
        
        
    } else {
        DLog(@"不需要的参数");
    }
    return YES;
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
