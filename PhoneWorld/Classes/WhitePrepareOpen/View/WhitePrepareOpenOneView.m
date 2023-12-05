//
//  WhitePrepareOpenOneView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/8.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "WhitePrepareOpenOneView.h"

@implementation WhitePrepareOpenOneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGROUND;
        [self phoneInputView];
        [self warningLabel];
        
        [self nextButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenWidth, 1)];
        lineView.backgroundColor = [Utils colorRGB:@"#eeeeee"];
        [self addSubview:lineView];
        
        _phoneInputView.leftLabel.text = @"号码";
        _phoneInputView.textField.placeholder = @"请输入号码";
        _phoneInputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return self;
}

- (InputView *)phoneInputView{
    if (_phoneInputView == nil) {
        _phoneInputView = [[InputView alloc] init];
        [self addSubview:_phoneInputView];
        [_phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        _phoneInputView.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _phoneInputView;
}

- (UILabel *)warningLabel{
    if (_warningLabel == nil) {
        _warningLabel = [[UILabel alloc] init];
        [self addSubview:_warningLabel];
        [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.phoneInputView.mas_bottom).mas_equalTo(17);
        }];
        _warningLabel.textAlignment = NSTextAlignmentRight;
        _warningLabel.font = [UIFont systemFontOfSize:textfont12];
        _warningLabel.textColor = [Utils colorRGB:@"#FF001F"];
        _warningLabel.numberOfLines = 0;
    }
    return _warningLabel;
}

- (UIButton *)nextButton{
    if (_nextButton == nil) {
        _nextButton = [Utils returnNextTwoButtonWithTitle:@"下一步"];
        [self addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-102);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(170);
        }];
    }
    return _nextButton;
}

@end
