//
//  LoginNewView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/12/10.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "LoginNewView.h"

@implementation LoginNewView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self backImageView];
        [self usernameTextField];
        [self passwordTextField];
//        [self forgetPasswordButton];
        [self loginButton];
//        [self registerButton];
        [self noteLabel];
        
//        UIView *lineView = [[UIView alloc] init];
//        lineView.backgroundColor = MainColor;
//        [self addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(0);
//            make.top.mas_equalTo(screenHeight - 64 - 55);
//            make.width.mas_equalTo(1);
//            make.height.mas_equalTo(20);
//        }];
        
    }
    return self;
}

- (UIImageView *)backImageView{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] init];
        [self addSubview:_backImageView];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-44);
            make.left.right.bottom.mas_equalTo(0);
        }];
        _backImageView.image = [UIImage imageNamed:@"TWorldBackImage"];
    }
    return _backImageView;
}

- (UITextField *)usernameTextField{
    if (_usernameTextField == nil) {
        _usernameTextField = [[UITextField alloc] init];
        [self addSubview:_usernameTextField];
        [_usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(-90);
        }];
        //设置左边显示图片
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"user"];
        [leftView addSubview:imageView];
        _usernameTextField.leftView = leftView;
        _usernameTextField.leftViewMode = UITextFieldViewModeAlways;
        //设置textField样式
//        _usernameTextField.placeholder = @"请输入用户名／手机号码";
        _usernameTextField.background = [UIImage imageNamed:@"textFieldBackground"];
        _usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入用户名／手机号码" attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
#if DEBUG
        _usernameTextField.text = @"app1";
#endif
    }
    return _usernameTextField;
}

- (UITextField *)passwordTextField{
    if (_passwordTextField == nil) {
        _passwordTextField = [[UITextField alloc] init];
        [self addSubview:_passwordTextField];
        [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.usernameTextField.mas_bottom).mas_equalTo(20);
        }];
        //设置左边显示图片
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"lock"];
        [leftView addSubview:imageView];
        _passwordTextField.leftView = leftView;
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        //设置textField样式
//        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.background = [UIImage imageNamed:@"textFieldBackground"];
//        [_passwordTextField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        #if DEBUG
            _passwordTextField.text = @"123";
        #endif
    }
    return _passwordTextField;
}

- (UIButton *)forgetPasswordButton{
    if (_forgetPasswordButton == nil) {
        _forgetPasswordButton = [[UIButton alloc] init];
        [self addSubview:_forgetPasswordButton];
        [_forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(screenHeight - 64 - 65);
            make.right.mas_equalTo(-(screenWidth/2 - 110));
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(40);
        }];
        [_forgetPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:textfont16];
        [_forgetPasswordButton setTitleColor:MainColor forState:UIControlStateNormal];
        [_forgetPasswordButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPasswordButton;
}

- (UIButton *)loginButton{
    if (_loginButton == nil) {
        _loginButton = [Utils returnNextButtonWithTitle:@"登    录"];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:textfont16];
        [self addSubview:_loginButton];
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(170);
            make.top.mas_equalTo(self.passwordTextField.mas_bottom).mas_equalTo(40);
        }];
        [_loginButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)registerButton{
    if (_registerButton == nil) {
        _registerButton = [[UIButton alloc] init];
        [self addSubview:_registerButton];
        [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(screenHeight - 64 - 65);
            make.width.mas_equalTo(100);
            make.left.mas_equalTo(screenWidth/2 - 110);
            make.height.mas_equalTo(40);
        }];
        [_registerButton setTitle:@"点击注册" forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:textfont16];
        [_registerButton setTitleColor:MainColor forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (void)buttonClickAction:(UIButton *)button{
    if ([button.currentTitle isEqualToString:@"登    录"]) {
        self.loginButton.userInteractionEnabled = NO;
    }
    _LoginCallBack(button.currentTitle);
}

- (UILabel *)noteLabel {
    if (_noteLabel == nil) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = @"温馨提醒：根据工信部文件要求，为防止工号和设备被滥用，开户工号需在工号注册地使用！使用App时请打开定位功能！";
        _noteLabel.font = [UIFont systemFontOfSize:14];
        [_noteLabel setTextColor:[UIColor redColor]];
        [self addSubview:_noteLabel];
        [_noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
//            make.top.mas_equalTo(self.loginButton.mas_bottom).offset(100);
            make.top.mas_equalTo(screenHeight - 64 - 200);
        }];
    }
    return _noteLabel;
}

@end
