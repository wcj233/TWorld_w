//
//  GetCodeViewController.m
//  PhoneWorld
//
//  Created by sheshe on 2022/2/18.
//  Copyright © 2022 xiyoukeji. All rights reserved.
//

#import "GetCodeViewController.h"
#import "ForgetPasswordView.h"

@interface GetCodeViewController ()
@property (nonatomic) ForgetPasswordView *forgetView;
@end

@implementation GetCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工号实名验证";
    self.view.backgroundColor = [Utils colorRGB:@"#f9f9f9"];
    self.forgetView = [[ForgetPasswordView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.forgetView];
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];

    self.forgetView.phoneNumTF.text = self.tel;
    self.forgetView.phoneNumTF.userInteractionEnabled = NO;
    [self.forgetView.nextButton setTitle:@"确定" forState:UIControlStateNormal];
    
    __block __weak GetCodeViewController *weakself = self;
    
    [self.forgetView setForgetCallBack:^(NSInteger tag, NSString *phoneNumber, NSString *codeString) {
        if (tag == 1103) {
            //确认
            [WebUtils requestCaptchaCheckWithCaptcha:codeString andType:6 andTel:phoneNumber andCallBack:^(id obj) {

                if (![obj isKindOfClass:[NSError class]]) {
                    NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                    if ([code isEqualToString:@"10000"]) {
                        //验证成功
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakself.CodeSuccessCallBack();
                        });
                    }else{
                        NSString *mes = [NSString stringWithFormat:@"%@",obj[@"mes"]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Utils toastview:mes];
                        });
                    }
                }
            }];
            
        }
        if(tag == 1104) {
            
            //发送验证码
            [WebUtils requestSendCaptchaWithType:6 andTel:phoneNumber andCallBack:^(id obj) {
                if (![obj isKindOfClass:[NSError class]]) {
                    NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                    if ([code isEqualToString:@"10000"]) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [Utils toastview:@"验证码已发送"];
//                        });
                    }else{
                        NSString *mes = [NSString stringWithFormat:@"%@",obj[@"mes"]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Utils toastview:mes];
                        });
                    }
                }
            }];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.forgetView buttonClickAction:self.forgetView.captchaButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.forgetView.link) {
        self.forgetView.link.paused = YES;
        self.forgetView.link = nil;
    }
}

@end
