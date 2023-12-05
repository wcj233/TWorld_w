//
//  CreatePayPasswordViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/15.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "CreatePayPasswordViewController.h"
#import "CreatePayPasswordView.h"
#import "FailedView.h"
#import "InputView.h"

@interface CreatePayPasswordViewController ()
@property (nonatomic) CreatePayPasswordView *createView;
@property (nonatomic) FailedView *succeedView;
@end

@implementation CreatePayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付密码创建";
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];

    self.createView = [[CreatePayPasswordView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.createView];
    @WeakObj(self);
    [self.createView setCreatePayPasswordCallBack:^(id obj) {
        @StrongObj(self);
        InputView *passV = self.createView.inputViews.firstObject;
        
        if (![Utils checkPayPassword:passV.textField.text]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utils toastview:@"请输入六位数字支付密码"];
            });
            return ;
        }
        
        self.createView.saveButton.userInteractionEnabled = NO;
        
        if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
            self.createView.userInteractionEnabled = YES;
        }
        
        [WebUtils requestCreatePayPasswordWithPassword:passV.textField.text andCallBack:^(id obj) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.createView.saveButton.userInteractionEnabled = YES;
            });
            
            if (![obj isKindOfClass:[NSError class]]) {
                
                
                if ([obj[@"code"] isEqualToString:@"10000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //操作
                        self.succeedView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"创建成功" andDetail:@"正在跳转..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
                        [[UIApplication sharedApplication].keyWindow addSubview:self.succeedView];
                        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissResultViewAction) userInfo:nil repeats:NO];
                    });
                }else{
                    NSString *detail = @"请重新创建！";
                    if ([obj[@"code"] isEqualToString:@"30002"]) {
                        detail = @"该用户支付密码已存在！";
                    }
                    //操作
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.succeedView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"创建失败" andDetail:detail andImageName:@"icon_cry" andTextColorHex:@"#0081eb"];
                        [[UIApplication sharedApplication].keyWindow addSubview:self.succeedView];
                        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissOnlyAction) userInfo:nil repeats:NO];
                    });
                    
                }
            }
        }];
    }];
}

- (void)dismissResultViewAction{
    [UIView animateWithDuration:0.5 animations:^{
        self.succeedView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.succeedView removeFromSuperview];
        if (self.type == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)dismissOnlyAction{
    [UIView animateWithDuration:0.5 animations:^{
        self.succeedView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.succeedView removeFromSuperview];
    }];
}

@end
