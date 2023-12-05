//
//  LoginNewViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/12/10.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "LoginNewViewController.h"
#import "LoginNewView.h"

#import "ForgetPasswordViewController.h"
#import "MainTabBarController.h"
#import "RegisterViewController.h"

#import "AppDelegate.h"
#import "WorkerSignInViewController.h"

#import "RedBagFillInfoVC.h"
#import "BaiduMapTool.h"
#import "WCJWorkSignViewController.h"

#import "GetCodeViewController.h" //不需要工号验证的话 先去手机号验证

@interface LoginNewViewController () <UITextFieldDelegate, BMKLocationManagerDelegate>

@property (nonatomic) LoginNewView *loginNewView;

@property (nonatomic) BOOL hasPassword;
@property (nonatomic) BOOL hasEdited;//是否密码框被编辑过
@property (strong, nonatomic) BMKLocationManager *locationManager;

@end

@implementation LoginNewViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated{
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.hidden = YES;
    // 先去请求一次定位，可以让用户先设置定位权限
    [self.locationManager requestLocationWithReGeocode:true withNetworkState:true completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {}];
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    
    if ([userD objectForKey:@"password"]) {
        self.loginNewView.passwordTextField.text = @"123456789012";
        self.loginNewView.usernameTextField.text = [userD objectForKey:@"username"];
        self.hasPassword = YES;
    }else{
        self.hasPassword = NO;
    }
    
    self.hasEdited = NO;
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (BMKLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        //_locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
    }
    return _locationManager;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //界面
    [[NSUserDefaults standardUserDefaults]setObject:@(0) forKey:@"工号登记"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    self.loginNewView = [[LoginNewView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.loginNewView.backgroundColor = UIColor.redColor;
    [self.view addSubview:self.loginNewView];
    
    //监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];
    
    self.loginNewView.passwordTextField.delegate = self;
    
    @WeakObj(self);
    //界面传过来的点击事件
    [self.loginNewView setLoginCallBack:^(NSString *title) {
        @StrongObj(self);
        if ([title isEqualToString:@"登    录"]) {
            NSString *username = self.loginNewView.usernameTextField.text;
            NSString *password = self.loginNewView.passwordTextField.text;
            if ([username isEqualToString:@""]) {
                [Utils toastview:@"请输入用户名"];
                self.loginNewView.loginButton.userInteractionEnabled = YES;
                return ;
            }
            if ([password isEqualToString:@""]) {
                [Utils toastview:@"请输入密码"];
                self.loginNewView.loginButton.userInteractionEnabled = YES;
                return;
            }
            //如果没网
            if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
                self.loginNewView.loginButton.userInteractionEnabled = YES;
            }
            
            NSString *passwordMD5 = self.loginNewView.passwordTextField.text;
            
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            
            //如果没有密码或者用户名和之前保存的不一致，说明是新的账号
            if (self.hasPassword == NO || ![[userD objectForKey:@"username"] isEqualToString:username]) {
                passwordMD5 = [Utils md5String:[NSString stringWithFormat:@"HJSJ%@2015GK#S",password]];//得到md5加密过后密码
            }else{
                //如果用户名一致
                //如果密码框没有被编辑过
                if (self.hasEdited == NO) {
                    passwordMD5 = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
                }else{
                    NSString *passwordCurrent = [Utils md5String:[NSString stringWithFormat:@"HJSJ%@2015GK#S",password]];
                    
                    passwordMD5 = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
                    
                    if (![passwordMD5 isEqualToString:passwordCurrent]) {
                        passwordMD5 = passwordCurrent;
                    }
                }
            }
            
            [WebUtils requestLoginResultWithUserName:username andPassword:passwordMD5 andWebUtilsCallBack:^(id obj) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.loginNewView.loginButton.userInteractionEnabled = YES;
                });
                if (![obj isKindOfClass:[NSError class]]) {
                    NSInteger code = [obj[@"code"] integerValue];
                    if (code == 10000) {
                        //缓存
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.view endEditing:YES];
                            
                            NSString *isFirstLogin = obj[@"data"][@"isLogin"];
                            if ([isFirstLogin isEqualToString:@"N"]) {
                                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                [ud setObject:@(1) forKey:@"工号登记"];
                                
                                [ud setObject:obj[@"data"][@"session_token"] forKey:@"session_token"];
                                [ud setObject:obj[@"data"][@"grade"] forKey:@"grade"];
                                
                                [ud removeObjectForKey:@"username"];
                                [ud removeObjectForKey:@"password"];
                                [ud synchronize];
                                
                                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                GetCodeViewController *vc = [[GetCodeViewController alloc] init];
                                vc.tel = obj[@"data"][@"tel"];
                                [[BaiduMapTool sharedInstance] checkLocationPermissionWithResultBlock:^(BOOL isOpen) {
                                    if (isOpen) {
                                        @WeakObj(self)
                                        [[BaiduMapTool sharedInstance] requestOnceLocationWithSuccessBlock:^(NSString * _Nonnull provinceCode, NSString * _Nonnull cityCode) {
                                            @StrongObj(self)
#if DEBUG
//                                            provinceCode = @"88";
//                                            cityCode = @"19";
#endif
                                            @WeakObj(self)
                                            [self showWaitView];
                                            NSString *province = provinceCode;
                                            NSString *city = cityCode;
                                            if ([provinceCode isEqualToString:city]) {//直辖市
                                                province = [city componentsSeparatedByString:@"市"].firstObject;
                                                city = province;
                                            }else{//不是直辖市--要去掉省--除了自治区
                                                if ([provinceCode containsString:@"省"]) {
                                                    province = [provinceCode componentsSeparatedByString:@"省"].firstObject;
                                                }else{
                                                    
                                                }
                                                city = [cityCode componentsSeparatedByString:@"市"].firstObject;
                                            }
                                            [WebUtils agency_judgeLocation:@{@"provinceCode": province, @"cityCode": city} andCallback:^(id obj) {
                                                [self hideWaitView];
                                                @StrongObj(self)
                                                NSInteger code = [obj[@"code"] integerValue];
                                                if (code == 10000) {
                                                    if ([obj[@"data"][@"judgeLocation"] boolValue] == true) {
                                                        
                                                        
                                                        vc.CodeSuccessCallBack = ^{
                                                            [ud setObject:username forKey:@"username"];
                                                            [ud setObject:passwordMD5 forKey:@"password"];
                                                            [ud synchronize];
                                                            [appDelegate gotoHomeVC];
                                                        };
                                                        
                                                        [self.navigationController pushViewController:vc animated:YES];
//
                                                    } else {
                                                        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户未在常用地使用" preferredStyle:UIAlertControllerStyleAlert];
                                                        UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                            return;
                                                        }];
                                                        [alertVC addAction:goAction];
                                                        [self presentViewController:alertVC animated:true completion:^{
                                                            [ud removeObjectForKey:@"session_token"];
                                                            [ud synchronize];
                                                        }];
                                                    }
                                                } else {
                                                    NSString *msg = obj[@"mes"];
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [Utils toastview:[NSString stringWithFormat:@"--%@", msg]];
                                                    });
                                                }
                                            }];
                                        } withErrorBlock:^(NSError * _Nonnull error) {

                                            vc.CodeSuccessCallBack = ^{
                                                [ud setObject:username forKey:@"username"];
                                                [ud setObject:passwordMD5 forKey:@"password"];
                                                [ud synchronize];
                                                [appDelegate gotoHomeVC];
                                            };
                                            
                                            [self.navigationController pushViewController:vc animated:YES];
                                        }];
                                    }
                                }];
                            }else{
                                //我自己加定位设置
                                [[BaiduMapTool sharedInstance] checkLocationPermissionWithResultBlock:^(BOOL isOpen) {
                                    if (isOpen) {
                                    
                                        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                        [ud setObject:obj[@"data"][@"session_token"] forKey:@"session_token"];
                                        [ud setObject:obj[@"data"][@"grade"] forKey:@"grade"];
                                        
                                        [ud removeObjectForKey:@"username"];
                                        [ud removeObjectForKey:@"password"];
                                        [ud synchronize];
                                        
                                        NSString *isCompare = obj[@"data"][@"isCompare"];
        //                                RedBagFillInfoVC *vc = [[RedBagFillInfoVC alloc]initWithForType:RedBagFillInfoVCTypeRealName isCompare:[isCompare isEqualToString:@"Y"]?YES:NO];
                                        WCJWorkSignViewController *vc = [[WCJWorkSignViewController alloc]init];
                                        vc.loginInfoDic = obj;
                                        vc.isCompare = [isCompare isEqualToString:@"Y"]?YES:NO;
                                        [self.navigationController pushViewController:vc animated:YES];
                                        
                                    }
                                }];
                                
                            }
                        });
                        
                    }else{
                        NSString *msg = obj[@"mes"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Utils toastview:[NSString stringWithFormat:@"%@", msg]];
                        });
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utils toastview:@"系统异常，请稍后重试！"];
                    });
                }
            }];
        }
        
        //页面跳转
        if ([title isEqualToString:@"点击注册"]) {
            RegisterViewController *vc = [[RegisterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([title isEqualToString:@"忘记密码？"]) {
            ForgetPasswordViewController *vc = [[ForgetPasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.hasPassword = NO;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.hasEdited = YES;
    return YES;
}

#pragma mark - 键盘即将弹出事件处理
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘信息
    NSDictionary *keyBoardInfo = [notification userInfo];
    
    //获取动画时间
    CGFloat duration = [[keyBoardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //获取键盘的frame信息
    //    NSValue *value = [keyBoardInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGSize keyboardSize = [value CGRectValue].size;
    
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.loginNewView.frame;
        frame.origin.y -= 100;
        self.loginNewView.frame = frame;
    } completion:nil];
}

#pragma mark - 键盘即将隐藏事件
- (void)keyboardWillHide:(NSNotification *)notification
{
    
    //获取键盘信息
    NSDictionary *keyBoardInfo = [notification userInfo];
    
    //获取动画时间
    CGFloat duration = [[keyBoardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //获取键盘的frame信息
    
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.loginNewView.frame;
        frame.origin.y = screenHeight - self.loginNewView.height;
        self.loginNewView.frame = frame;
    } completion:nil];
}

@end
