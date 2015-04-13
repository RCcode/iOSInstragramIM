//
//  PS_LoginViewController.m
//  iPhotoSocial
//
//  Created by lisongrc on 15-4-1.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import "PS_LoginViewController.h"

@interface PS_LoginViewController ()<UIWebViewDelegate>

@end

@implementation PS_LoginViewController

-(void)dealloc
{
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelButonOnClick:)];
    self.navigationItem.leftBarButtonItem = barButton;
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    web.delegate = self;
    [self.view addSubview:web];
    
    NSString *loginUrl = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code&scope=likes+relationships",kClientId,kRedirectUri];
    NSURL *url = [NSURL URLWithString:loginUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
}

- (void)cancelButonOnClick:(UIBarButtonItem *)barButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- UIWebViewDelegate --
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"navigationType%ld",navigationType);
    if (navigationType == UIWebViewNavigationTypeFormSubmitted && [request.URL.absoluteString rangeOfString:@"code="].length > 0) {
        NSString *codeStr = [[request.URL.absoluteString componentsSeparatedByString:@"code="] lastObject];
        NSLog(@"absoluteString == %@",request.URL.absoluteString);
        NSLog(@"dfgdfgdf%@",codeStr);
        self.loginSuccessBlock(codeStr);
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error.localizedDescription);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
