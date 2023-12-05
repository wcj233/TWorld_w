//
//  MainNavigationController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/11.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "MainNavigationController.h"

#import "RightItemView.h"
#import "MessageViewController.h"
#import "PersonalHomeViewController.h"

//#import "TopBarView.h"

@interface MainNavigationController ()
//@property (nonatomic) TopBarView *topBarView;
@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.tintColor = MainColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:MainColor};
    self.navigationBar.translucent = NO;
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance * bar = [UINavigationBarAppearance new];
        bar.backgroundColor = [UIColor whiteColor];
        bar.backgroundEffect = nil;
        self.navigationBar.scrollEdgeAppearance = bar;
        self.navigationBar.standardAppearance = bar;
    } else {
        // Fallback on earlier versions
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //    UIImageView *lineImageView = [self findHairlineImageViewUnder:self.navigationBar];
    //    lineImageView.hidden = YES;
    
    //当管理页面为1的时候(只显示一级页面的时候才添加)
    if(self.viewControllers.count == 1){
        
        //得到显示的页面再添加按钮
        RightItemView *rightItemView = [[RightItemView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        
        
        
        [rightItemView.rightButton addTarget:self action:@selector(gotoMessagesVC) forControlEvents:UIControlEventTouchUpInside];
        
        rightItemView.redLabel.hidden = YES;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *hidden = [ud objectForKey:@"redItem"];
        if (hidden) {
            if ([hidden isEqualToString:@"YES"]) {
                rightItemView.redLabel.hidden = YES;
            }else{
                rightItemView.redLabel.hidden = NO;
            }
        }else{
            rightItemView.redLabel.hidden = NO;
        }
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
        
        self.topViewController.navigationItem.rightBarButtonItem = rightItem;
        
        self.topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_tabbar_icon_me"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoPersonalHomeVC)];
    }
}

- (void)gotoMessagesVC{
    MessageViewController *messageVC = [MessageViewController new];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self pushViewController:messageVC animated:YES];
}

- (void)gotoPersonalHomeVC{
    PersonalHomeViewController *vc = [PersonalHomeViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:vc animated:YES];
}

@end
