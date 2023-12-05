//
//  OpenSucceedView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "OpenSucceedView.h"

@implementation OpenSucceedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self backView];
        [self whiteBackView];
        [self showImageView];
        [self warningLabel];
    }
    return self;
}

- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.4;
    }
    return _backView;
}

- (UIView *)whiteBackView{
    if (_whiteBackView == nil) {
        _whiteBackView = [[UIView alloc] init];
        [self addSubview:_whiteBackView];
        [_whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.centerX.centerY.mas_equalTo(0);
            make.height.mas_equalTo(164);
        }];
        _whiteBackView.layer.cornerRadius = 10;
        _whiteBackView.layer.masksToBounds = YES;
        _whiteBackView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBackView;
}

- (UIImageView *)showImageView{
    if (_showImageView == nil) {
        _showImageView = [[UIImageView alloc] init];
        [self addSubview:_showImageView];
        [_showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(97.7);
            make.centerY.mas_equalTo(self.whiteBackView.mas_top);
        }];
        _showImageView.image = [UIImage imageNamed:@"popup_icon_successfuldeposit"];
    }
    return _showImageView;
}

- (UILabel *)warningLabel{
    if (_warningLabel == nil) {
        _warningLabel = [[UILabel alloc] init];
        [self.whiteBackView addSubview:_warningLabel];
        [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(50);
        }];
        _warningLabel.textColor = MainColor;
        _warningLabel.text = @"开户成功！";
        _warningLabel.font = [UIFont systemFontOfSize:textfont16];
        _warningLabel.textAlignment = NSTextAlignmentCenter;
        _warningLabel.numberOfLines = 0;
    }
    return _warningLabel;
}

@end
