//
//  LIdentifyPhoneNumberView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/15.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "LIdentifyPhoneNumberView.h"

@implementation LIdentifyPhoneNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self phoneTextField];
        [self codeTextField];
        [self getCodeButton];
        [self nextButton];
    }
    return self;
}

- (UITextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
        [self addSubview:_phoneTextField];
        _phoneTextField.placeholder = @"请输入手机号码";
        _phoneTextField.font = font16;
        _phoneTextField.textColor = [Utils colorRGB:@"#999999"];
        _phoneTextField.backgroundColor = [UIColor whiteColor];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_phonenumber"]];
        imageView.frame = CGRectMake(15, 11, 22, 22);
        [leftView addSubview:imageView];
        _phoneTextField.leftView = leftView;
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneTextField;
}

- (UITextField *)codeTextField{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 46, screenWidth, 44)];
        [self addSubview:_codeTextField];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.font = font16;
        _codeTextField.textColor = [Utils colorRGB:@"#999999"];
        _codeTextField.backgroundColor = [UIColor whiteColor];
        _codeTextField.keyboardType=UIKeyboardTypeNumberPad;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_securitycode"]];
        imageView.frame = CGRectMake(15, 11, 22, 22);
        [leftView addSubview:imageView];
        _codeTextField.leftView = leftView;
        _codeTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _codeTextField;
}

- (UIButton *)getCodeButton{
    if (!_getCodeButton) {
        _getCodeButton = [[UIButton alloc] init];
        [self addSubview:_getCodeButton];
        [_getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(24);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.codeTextField);
        }];
        _getCodeButton.layer.borderWidth = 1.0;
        _getCodeButton.layer.cornerRadius = 4.0;
        _getCodeButton.layer.borderColor = [Utils colorRGB:@"#4A90E2"].CGColor;
        _getCodeButton.layer.masksToBounds = YES;
        [_getCodeButton setTitleColor:[Utils colorRGB:@"#4A90E2"] forState:UIControlStateNormal];
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeButton.titleLabel.font = font12;
    }
    return _getCodeButton;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [Utils returnNextTwoButtonWithTitle:@"下一步"];
        [self addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-127);
            make.width.mas_equalTo(170);
            make.height.mas_equalTo(41);
        }];
    }
    return _nextButton;
}

@end
