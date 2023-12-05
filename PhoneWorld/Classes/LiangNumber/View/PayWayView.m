//
//  PayWayView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/12.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "PayWayView.h"

@implementation PayWayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self leftButton];
        [self rightLabel];
        [self titleLabel];
    }
    return self;
}

- (UIButton *)leftButton{
    if (_leftButton == nil) {
        _leftButton = [[UIButton alloc] init];
        [self addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(20);
        }];
        _leftButton.layer.borderColor = [Utils colorRGB:@"#008bd5"].CGColor;
        _leftButton.layer.borderWidth = 6;
        _leftButton.layer.cornerRadius = 10;
        _leftButton.userInteractionEnabled = NO;
        _leftButton.layer.masksToBounds = YES;
    }
    return _leftButton;
}

- (UILabel *)rightLabel{
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        [self addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
        }];
        _rightLabel.userInteractionEnabled = NO;
        _rightLabel.textColor = MainColor;
        _rightLabel.font = [UIFont systemFontOfSize:textfont14];
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(self.leftButton.mas_right).mas_equalTo(8);
            make.right.mas_equalTo(self.rightLabel.mas_left).mas_equalTo(-8);
        }];
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.font = [UIFont systemFontOfSize:textfont16];
        _titleLabel.textColor = [Utils colorRGB:@"#333333"];
    }
    return _titleLabel;
}

@end
