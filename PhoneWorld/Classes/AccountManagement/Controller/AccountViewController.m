//
//  AccountViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/11.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "AccountViewController.h"

#import "PhoneCashCheckViewController.h"
#import "CheckAndTopViewController.h"
#import "TopCallMoneyViewController.h"
#import "TopAndInquiryViewController.h"

#import "AccountView.h"

@interface AccountViewController ()

@property (nonatomic) AccountView *accountView;

@end

@implementation AccountViewController
#pragma mark - LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = [Utils returnBackButton];
    
    self.accountView = [[AccountView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.accountView];
    @WeakObj(self);
    [self.accountView setAccountCallBack:^(NSInteger row) {
        @StrongObj(self);
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        switch (row) {
            case 0:{
                NSInteger i1 = [ud integerForKey:@"accountRecord"];
                i1 = i1 + 1;
                [ud setInteger:i1 forKey:@"accountRecord"];
                [ud synchronize];
                
                CheckAndTopViewController *vc = [CheckAndTopViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
        }
    }];
}

@end
