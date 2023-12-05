//
//  LoginNaviViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/12/15.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "LoginNaviViewController.h"

@interface LoginNaviViewController ()

@end

@implementation LoginNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [Utils colorRGB:@"#999999"];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:MainColor};
    UIImageView *lineImageView = [Utils findHairlineImageViewUnder:self.navigationBar];
    lineImageView.hidden = YES;
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviBack"] forBarMetrics:UIBarMetricsDefault];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance * bar = [UINavigationBarAppearance new];
        bar.backgroundColor = [UIColor whiteColor];
        bar.backgroundEffect = nil;
        self.navigationBar.scrollEdgeAppearance = bar;
        self.navigationBar.standardAppearance = bar;
        [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    } else {
        // Fallback on earlier versions
    }
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//}


@end
