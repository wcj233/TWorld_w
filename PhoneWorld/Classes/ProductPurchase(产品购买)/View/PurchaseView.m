//
//  PurchaseView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/3.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "PurchaseView.h"

@implementation PurchaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self topView];
        [self leftImageView];
        [self nameLabel];
        [self introduceLabel];
        [self priceLabel];
        [self phoneInputView];
        [self warningLabel];
        [self submitButton];
    }
    return self;
}

- (UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        [self addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(100);
        }];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UIImageView *)leftImageView{
    if (_leftImageView == nil) {
        _leftImageView = [[UIImageView alloc] init];
        [self.topView addSubview:_leftImageView];
        [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(69);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _leftImageView;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        [self.topView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftImageView.mas_right).mas_equalTo(18);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(16);
        }];
        _nameLabel.textColor = [Utils colorRGB:@"#333333"];
        _nameLabel.font = [UIFont systemFontOfSize:textfont16];
    }
    return _nameLabel;
}

- (UILabel *)introduceLabel{
    if (_introduceLabel == nil) {
        _introduceLabel = [[UILabel alloc] init];
        [self.topView addSubview:_introduceLabel];
        [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftImageView.mas_right).mas_equalTo(18);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(5);
            make.height.mas_equalTo(24);
        }];
        _introduceLabel.numberOfLines = 2;
        _introduceLabel.font = [UIFont systemFontOfSize:12];
        _introduceLabel.textColor = [Utils colorRGB:@"#666666"];
    }
    return _introduceLabel;
}

- (UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        [self.topView addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftImageView.mas_right).mas_equalTo(18);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.introduceLabel.mas_bottom).mas_equalTo(10);
            make.height.mas_equalTo(14);
        }];
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.textColor = [Utils colorRGB:@"#EC6C00"];
    }
    return _priceLabel;
}

- (InputView *)phoneInputView{
    if (_phoneInputView == nil) {
        _phoneInputView = [[InputView alloc] init];
        [self addSubview:_phoneInputView];
        _phoneInputView.leftLabel.text = @"号码";
        _phoneInputView.textField.placeholder = @"请输入号码 ";
        [_phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.topView.mas_bottom).mas_equalTo(5);
            make.height.mas_equalTo(44);
        }];
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
        _warningLabel.hidden = YES;
        _warningLabel.text = @"您的号码输入有误！";
        _warningLabel.font = [UIFont systemFontOfSize:12];
        _warningLabel.textColor = [Utils colorRGB:@"#ff001f"];
        _warningLabel.textAlignment = NSTextAlignmentRight;
    }
    return _warningLabel;
}


- (UIButton *)submitButton{
    if (_submitButton == nil) {
        _submitButton = [Utils returnNextTwoButtonWithTitle:@"提交"];
        [self addSubview:_submitButton];
        [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-102);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(170);
        }];
    }
    return _submitButton;
}

@end
