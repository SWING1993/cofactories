//
//  EnterpriseShowWeb_VC.m
//  Cofactories
//
//  Created by GTF on 16/3/7.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "EnterpriseShowWeb_VC.h"

@interface EnterpriseShowWeb_VC ()

@end

@implementation EnterpriseShowWeb_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.frame];
    AFOAuthCredential *auth = [HttpClient getToken];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?accessToken=%@",_urlStr,auth.accessToken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
}

@end
