//
//  HomeJumpViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/11/3.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "HomeJumpViewController.h"

@interface HomeJumpViewController ()<UIWebViewDelegate>

@property (nonatomic) UIWebView *webView;

@end

@implementation HomeJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACKGROUND;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];

    [self showWaitView];
    
}

#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideWaitView];
}


@end
