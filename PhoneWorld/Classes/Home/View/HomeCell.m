//
//  HomeCell.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/11.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "HomeCell.h"

#define bottomY (self.height - (self.width - 40) - 26)/2

@implementation HomeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self imageV];
        [self titleLb];
    }
    return self;
}

- (UIImageView *)imageV{
    if(_imageV == nil){
        _imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(45);
        }];
    }
    return _imageV;
}

- (UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLb];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.font = [UIFont systemFontOfSize:textfont16];
        _titleLb.textColor = [Utils colorRGB:@"#666666"];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.mas_equalTo(0);
            make.height.mas_equalTo(14);
            make.top.mas_equalTo(self.imageV.mas_bottom).mas_equalTo(12);
        }];
    }
    return _titleLb;
}


@end
