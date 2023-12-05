//
//  LIdentifyPhoneNumberViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/15.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "LIdentifyPhoneNumberViewController.h"
#import "LIdentifyPhoneNumberView.h"
#import "ChooseProductViewController.h"
#import "LCanBookModel.h"
#import "RightsModel.h"

#import "MemberSystemVC.h"

@interface LIdentifyPhoneNumberViewController ()

@property (nonatomic, strong) LIdentifyPhoneNumberView *numberView;

@property (nonatomic, strong) NSMutableArray *productArray;

@property (nonatomic, strong) NSTimer *countDownTimer;

@property (nonatomic, assign) NSInteger type;

@end

@implementation LIdentifyPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号验证";
    [self initInterface];
    [self buttonClickedAction];
}

- (instancetype )initWithType:(NSInteger )type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)initInterface{
    self.numberView = [[LIdentifyPhoneNumberView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.numberView];
}

- (void)buttonClickedAction{
    [self.numberView.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.numberView.getCodeButton addTarget:self action:@selector(verifyPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nextAction{
    if ([self.numberView.phoneTextField.text isEqualToString:@""]) {
        [Utils toastview:@"请输入手机号"];
        return;
    }
    if ([self.numberView.codeTextField.text isEqualToString:@""]) {
        [Utils toastview:@"请输入验证码"];
        return;
    }
    if ([Utils isNumber:self.numberView.codeTextField.text] == NO) {
        [Utils toastview:@"请输入数字验证码"];
        return;
    }
    
//    [self getTheCorrespondingData];
//    return;
    
    [self showWaitView];
    @WeakObj(self);
    [WebUtils requestCaptchaCheckWithCaptcha:self.numberView.codeTextField.text andType:6 andTel:self.numberView.phoneTextField.text andCallBack:^(id obj) {
        @StrongObj(self);
        [self hideWaitView];
        if (![obj isKindOfClass:[NSError class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];

            if ([code isEqualToString:@"10000"]) {
            
                [self getTheCorrespondingData];
            
            }else{
                [Utils toastview:obj[@"mes"]];
            }
        }
    }];
    
//    [WebUtils l_getProduct:self.numberView.phoneTextField.text andVerificationCode:self.numberView.codeTextField.text andCallBack:^(id obj) {
//        [self hideWaitView];
//
//        if (![obj isKindOfClass:[NSError class]]) {
//            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
//            if ([code isEqualToString:@"10000"]) {
//
//                //数据解析
//                NSDictionary *dic = (NSDictionary *)obj;
//                NSArray *array = dic[@"data"][@"productList"];
//
//                self.productArray = [NSMutableArray array];
//
//                for (NSDictionary *dataDic in array) {
//                    LCanBookModel *model = [[LCanBookModel alloc] initWithDictionary:dataDic error:nil];
//                    [self.productArray addObject:model];
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (self.countDownTimer.isValid) {
//                        [self.countDownTimer invalidate];  // 从运行循环中移除， 对运行循环的引用进行一次 release
//                        self.numberView.getCodeButton.enabled = YES;
//                        [self.numberView.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//                        self.countDownTimer=nil;            // 将销毁定时器
//                    }
//                    ChooseProductViewController *vc = [[ChooseProductViewController alloc] init];
//                    vc.productArray = self.productArray;
//                    vc.phoneNumber = self.numberView.phoneTextField.text;
//                    vc.verificationCode = self.numberView.codeTextField.text;
//                    self.numberView.phoneTextField.text=@"";
//                    self.numberView.codeTextField.text=@"";
//                    [self.navigationController pushViewController:vc animated:YES];
//                });
//            }else{
//                [self showWarningText:obj[@"mes"]];
//            }
//        }
//    }];
}

- (void)getTheCorrespondingData{
    [self showWaitView];
    @WeakObj(self);
    [WebUtils agency_2019QueryProductsWithParams:@{@"type":@(self.type + 1)} andCallback:^(id obj) {
        @StrongObj(self);
            [self hideWaitView];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    
                    //数据解析
                    NSDictionary *dic = (NSDictionary *)obj;
                    NSArray *array = @[];
                    if (self.type == 1){
                        array = dic[@"data"][@"products"][@"dataProds"];
                    }else{
                        array = dic[@"data"][@"products"][@"privilegeProds"];
                    }
                    self.productArray = [NSMutableArray array];
                        
                    for (NSDictionary *dataDic in array) {
                        RightsModel *model = [RightsModel yy_modelWithJSON:dataDic];
                        [self.productArray addObject:model];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.countDownTimer.isValid) {
                            [self.countDownTimer invalidate];  // 从运行循环中移除， 对运行循环的引用进行一次 release
                            self.numberView.getCodeButton.enabled = YES;
                            [self.numberView.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                            self.countDownTimer=nil;            // 将销毁定时器
                        }
                        MemberSystemVC *vc = [[MemberSystemVC alloc]initWithBusinessList:self.productArray andPhone:self.numberView.phoneTextField.text];
                        if (self.type == 1){
                            vc.navigationItem.title = @"流量包";
                        }else{
                            vc.navigationItem.title = @"会员";
                        }
                        self.numberView.phoneTextField.text=@"";
                        self.numberView.codeTextField.text=@"";
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                }else{
                    [self showWarningText:obj[@"mes"]];
                }
                
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }];
}

- (void)verifyPhoneNumber{
    if ([Utils isMobile:self.numberView.phoneTextField.text] == NO) {
        [Utils toastview:@"请输入正确手机号"];
        return;
    }
    
    @WeakObj(self);
    [WebUtils requestSegmentWithTel:self.numberView.phoneTextField.text andCallBack:^(id obj) {
        @StrongObj(self);
        if (![obj isKindOfClass:[NSError class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                [self getCodeAction];
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }else{
            [self showWarningText:@"请求出错"];
        }
    }];
}

- (void)getCodeAction{
    
    [self showWaitView];
    
    @WeakObj(self);
    [WebUtils requestSendCaptchaWithType:6 andTel:self.numberView.phoneTextField.text andCallBack:^(id obj) {
        @StrongObj(self);
        [self hideWaitView];
        NSLog(@"验证码在这里！%@",obj);
        if (![obj isKindOfClass:[NSError class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                [Utils toastview:@"验证码发送成功"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.numberView.getCodeButton setTitle:@"90s" forState:UIControlStateNormal];
                    self.numberView.getCodeButton.enabled = NO;

                    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
                });
                
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
    
//    [WebUtils l_getCode:self.numberView.phoneTextField.text andCallBack:^(id obj) {
//        [self hideWaitView];
//        NSLog(@"验证码在这里！%@",obj);
//        if (![obj isKindOfClass:[NSError class]]) {
//            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
//            if ([code isEqualToString:@"10000"]) {
//                [Utils toastview:@"验证码发送成功"];
//            }else{
//                [self showWarningText:obj[@"mes"]];
//            }
//        }
//    }];
}

- (void)countDownAction{
    NSInteger number = [self.numberView.getCodeButton.currentTitle componentsSeparatedByString:@"s"].firstObject.integerValue;
    number --;
    [self.numberView.getCodeButton setTitle:[NSString stringWithFormat:@"%lds",number] forState:UIControlStateNormal];

    if (number == 0) {
        [self.countDownTimer invalidate];
        self.numberView.getCodeButton.enabled = YES;
        [self.numberView.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

@end
