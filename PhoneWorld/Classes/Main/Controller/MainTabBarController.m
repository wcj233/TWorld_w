//
//  MainTabBarController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/11.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "AccountViewController.h"
#import "CardViewController.h"
#import "MainNavigationController.h"
#import "LOrderViewController.h"
#import "SOrderViewController.h"//二期订单查询

#import "ChannelPartnersManageViewController.h"

@interface MainTabBarController ()<UITabBarControllerDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.title = @"话机世界";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"tab1"];
    homeVC.tabBarItem.title = @"首页";
    
    SOrderViewController *orderNewVC = [[SOrderViewController alloc] init];
    orderNewVC.title = @"订单查询";
    orderNewVC.tabBarItem.image = [UIImage imageNamed:@"tab2"];
    orderNewVC.tabBarItem.title = @"订单查询";
    
    ChannelPartnersManageViewController *channelVC = [ChannelPartnersManageViewController sharedChannelPartnersManageViewController];
    channelVC.title = @"渠道商管理";
    channelVC.tabBarItem.image = [UIImage imageNamed:@"tab2"];
    channelVC.tabBarItem.title = @"渠道商管理";
    
    AccountViewController *accountVC = [AccountViewController new];
    accountVC.title = @"账户管理";
    accountVC.tabBarItem.image = [UIImage imageNamed:@"tab3"];
    accountVC.tabBarItem.title = @"账户管理";
    
    CardViewController *cardVC = [CardViewController new];
    cardVC.title = @"业务管理";
    cardVC.tabBarItem.image = [UIImage imageNamed:@"tab4"];
    cardVC.tabBarItem.title = @"业务管理";
    
    //区分用户等级
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *grade = [ud objectForKey:@"grade"];
    
    if ([grade isEqualToString:@"lev1"] || [grade isEqualToString:@"lev2"]) {
        //代理商 功能少
        
        self.viewControllers = @[[[MainNavigationController alloc] initWithRootViewController:homeVC], [[MainNavigationController alloc] initWithRootViewController:channelVC], [[MainNavigationController alloc] initWithRootViewController:cardVC]];

        
    }else if([grade isEqualToString:@"lev3"]){
        //渠道商  功能多
        
        self.viewControllers = @[[[MainNavigationController alloc] initWithRootViewController:homeVC], [[MainNavigationController alloc] initWithRootViewController:orderNewVC], [[MainNavigationController alloc] initWithRootViewController:accountVC], [[MainNavigationController alloc] initWithRootViewController:cardVC]];
        
    }else if([grade isEqualToString:@"lev0"]){
        //lev0 总 话机最高帐号
        
        self.viewControllers = @[[[MainNavigationController alloc] initWithRootViewController:homeVC], [[MainNavigationController alloc] initWithRootViewController:orderNewVC], [[MainNavigationController alloc] initWithRootViewController:channelVC], [[MainNavigationController alloc] initWithRootViewController:accountVC], [[MainNavigationController alloc] initWithRootViewController:cardVC]];
    }
    
    
    if (@available(iOS 15.0, *)) {
        UITabBarAppearance * appearance = [[UITabBarAppearance alloc] init];
        appearance.backgroundColor = UIColor.whiteColor;
        self.tabBar.scrollEdgeAppearance = appearance;
        self.tabBar.standardAppearance = appearance;
        
        UINavigationBarAppearance *bar = [UINavigationBarAppearance new];
        bar.backgroundColor = [UIColor whiteColor];
        bar.backgroundEffect = nil;
        [[UINavigationBar appearance] setScrollEdgeAppearance: bar];
        [[UINavigationBar appearance] setStandardAppearance:bar];
    }
    
    self.tabBar.tintColor = MainColor;
    self.tabBar.translucent = NO;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

@end
