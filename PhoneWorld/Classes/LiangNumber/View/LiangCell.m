//
//  LiangCell.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "LiangCell.h"

@implementation LiangCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self leadImageView];
        [self placeLabel];
        [self phoneNumberLabel];
    }
    return self;
}

- (UIImageView *)leadImageView{
    if (_leadImageView == nil) {
        _leadImageView = [[UIImageView alloc] init];
        [self addSubview:_leadImageView];
        [_leadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(13);
            make.centerY.mas_equalTo(0);
        }];
        _leadImageView.image = [UIImage imageNamed:@"right"];
    }
    return _leadImageView;
}

- (UILabel *)placeLabel{
    if (_placeLabel == nil) {
        _placeLabel = [[UILabel alloc] init];
        [self addSubview:_placeLabel];
        [_placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(self.leadImageView.mas_left).mas_equalTo(-5);
        }];
        _placeLabel.textColor = [Utils colorRGB:@"#333333"];
        _placeLabel.font = font14;
    }
    return _placeLabel;
}

- (UILabel *)phoneNumberLabel{
    if (_phoneNumberLabel == nil) {
        _phoneNumberLabel = [[UILabel alloc] init];
        [self addSubview:_phoneNumberLabel];
        [_phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self.placeLabel.mas_left).mas_equalTo(-10);
        }];
        _phoneNumberLabel.textColor = [Utils colorRGB:@"#333333"];
        _phoneNumberLabel.font = font14;
    }
    return _phoneNumberLabel;
}


@end
