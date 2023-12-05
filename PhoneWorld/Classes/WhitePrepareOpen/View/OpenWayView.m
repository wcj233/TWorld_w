//
//  OpenWayView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "OpenWayView.h"

@implementation OpenWayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self backImageView];
        [self titleLabel];
        [self chooseButton];
    }
    return self;
}

- (UIImageView *)backImageView{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] init];
        [self addSubview:_backImageView];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _backImageView;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-22);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(18);
        }];
        _titleLabel.font = [UIFont systemFontOfSize:textfont18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)chooseButton{
    if (_chooseButton == nil) {
        _chooseButton = [[UIButton alloc] init];
        [_chooseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_chooseButton setTitle:@"选择" forState:UIControlStateNormal];
        _chooseButton.titleLabel.font = [UIFont systemFontOfSize:textfont16];
        [self addSubview:_chooseButton];
        [_chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(33);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(120);
        }];
        _chooseButton.layer.cornerRadius = 4;
        _chooseButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _chooseButton.layer.borderWidth = 1.0;
        _chooseButton.layer.masksToBounds = YES;
    }
    return _chooseButton;
}

@end
