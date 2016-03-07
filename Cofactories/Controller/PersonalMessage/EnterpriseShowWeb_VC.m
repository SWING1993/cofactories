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
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
}

@end
