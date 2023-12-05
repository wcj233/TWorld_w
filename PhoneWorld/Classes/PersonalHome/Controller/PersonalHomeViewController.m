//
//  PersonalHomeViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/11.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "PersonalHomeViewController.h"
#import "PersonalHomeView.h"
#import "PersonalInfoViewController.h"
#import "PasswordManageViewController.h"
#import "SettingViewController.h"
#import "MessageViewController.h"
#import "CommisionCountViewController.h"
#import "LoginNaviViewController.h"
#import "LoginNewViewController.h"
#import "AppDelegate.h"

@interface PersonalHomeViewController ()
@property (nonatomic) PersonalHomeView *personalHomeView;
@end

@implementation PersonalHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];
    
    self.personalHomeView = [[PersonalHomeView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.personalHomeView];
    __block __weak PersonalHomeViewController *weakself = self;
    [self.personalHomeView setPersonalHomeCallBack:^(NSInteger number) {
        switch (number) {
            case 0:
            {//个人信息
                PersonalInfoViewController *vc = [PersonalInfoViewController new];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {//密码管理
                PasswordManageViewController *vc = [PasswordManageViewController new];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {//消息中心
                MessageViewController *vc = [MessageViewController new];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {//佣金统计
//                CommisionCountViewController *vc = [CommisionCountViewController new];
//                [weakself.navigationController pushViewController:vc animated:YES];
                UIStoryboard* story = [UIStoryboard storyboardWithName:@"Brokerage" bundle:nil];
                UIViewController *vc=[story instantiateViewControllerWithIdentifier:@"BrokerageViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {//设置
                SettingViewController *vc = [SettingViewController new];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 111:{//登出
                
                [WebUtils requestLogoutResultWithCallBack:^(id obj) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        if ([obj[@"code"] isEqualToString:@"10000"]) {
                            
                            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                            [ud removeObjectForKey:@"session_token"];
                            [ud removeObjectForKey:@"grade"];
                            [ud removeObjectForKey:@"hasPayPassword"];
                            [ud synchronize];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
                                keyWindow.rootViewController = [[LoginNaviViewController alloc] initWithRootViewController:[LoginNewViewController new]];
                            });
                            
                        }
                    }
                }];
            }
                break;
        }
    }];
}

@end
