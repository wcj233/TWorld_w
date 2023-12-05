//
//  STableHeadView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/5.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "STableHeadView.h"

@implementation STableHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Utils colorRGB:@"#DDDDDD"];
        [self countLabel];
        [self centerLabel];
        [self rightLabel];
    }
    return self;
}

- (UILabel *)countLabel{
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        [self addSubview:_countLabel];
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
        _countLabel.font = [UIFont systemFontOfSize:13];
        _countLabel.textColor = [Utils colorRGB:@"#999999"];
    }
    return _countLabel;
}

- (UILabel *)centerLabel{
    if (_centerLabel == nil) {
        _centerLabel = [[UILabel alloc] init];
        [self addSubview:_centerLabel];
        [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.countLabel.mas_right).mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
        _centerLabel.font = [UIFont systemFontOfSize:12];
        _centerLabel.textColor = [Utils colorRGB:@"#999999"];
    }
    return _centerLabel;
}

- (UILabel *)rightLabel{
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        [self addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.centerLabel.mas_right).mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
        _rightLabel.font = [UIFont systemFontOfSize:12];
        _rightLabel.textColor = [Utils colorRGB:@"#EC6C00"];
    }
    return _rightLabel;
}

@end
